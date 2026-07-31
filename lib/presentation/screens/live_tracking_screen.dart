import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../models/transit_models.dart';
import '../../services/transit_repository.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/slide_route.dart';
import 'bus_details_screen.dart';

// Approximate coordinates for the stop names already used in
// bus_details_screen.dart's route list. Doubles as the path a bus marker
// follows locally whenever no real GPS feed has posted a location for
// [kDemoBusId] yet -- e.g. before a driver app or dispatcher account exists.
const _routePath = <LatLng>[
  LatLng(-1.9705, 30.0959), // Downtown Terminal
  LatLng(-1.9441, 30.0619), // Nyabugogo
  LatLng(-1.9578, 30.1127), // Remera
  LatLng(-1.9333, 30.1210), // Kimironko
];
const _routeStopNames = ['Downtown Terminal', 'Nyabugogo', 'Remera', 'Kimironko'];

class LiveTrackingScreen extends StatefulWidget {
  final String busId;
  const LiveTrackingScreen({super.key, this.busId = kDemoBusId});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final _repository = TransitRepository();

  bool _sheetUp = false;
  Timer? _fallbackTimer;
  int _fallbackStep = 0;
  LatLng _fallbackPosition = _routePath.first;
  bool _isLive = false;
  LatLng? _livePosition;
  StreamSubscription<BusLocation?>? _locationSub;
  Map<String, dynamic>? _busData;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _busSub;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _sheetUp = true);
    });

    _fallbackTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_isLive || !mounted) return;
      setState(() {
        _fallbackStep = (_fallbackStep + 1) % _routePath.length;
        _fallbackPosition = _routePath[_fallbackStep];
      });
    });

    _locationSub = _repository.watchBusLocation(widget.busId).listen(
      (location) {
        if (!mounted || location == null) return;
        setState(() {
          _isLive = true;
          _livePosition = LatLng(location.latitude, location.longitude);
        });
      },
      onError: (_) {},
    );

    _busSub = _repository.watchBus(widget.busId).listen(
      (snapshot) {
        if (!mounted) return;
        setState(() => _busData = snapshot.data());
      },
      onError: (_) {},
    );
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _locationSub?.cancel();
    _busSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final busPosition = _isLive ? _livePosition! : _fallbackPosition;
    final nextStop = _busData?['nextStop'] as String? ?? _routeStopNames[_fallbackStep];
    final etaMinutes = _busData?['etaMinutes'];
    final etaLabel = etaMinutes is num ? '$etaMinutes minutes' : 'about 8 minutes';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                PillBackButton(onTap: () => Navigator.of(context).pop()),
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(target: _routePath.first, zoom: 13),
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        markers: {
                          Marker(
                            markerId: const MarkerId('bus'),
                            position: busPosition,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                            infoWindow: InfoWindow(title: _busData?['busNumber'] as String? ?? 'Bus 103'),
                          ),
                        },
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _LiveBadge(isLive: _isLive),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedSlide(
                          offset: _sheetUp ? Offset.zero : const Offset(0, 1),
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: _sheetUp ? 1 : 0,
                            duration: const Duration(milliseconds: 420),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                              decoration: BoxDecoration(
                                color: context.colors.surface,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, -8)),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Next Stop', style: TextStyle(color: context.colors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Text(
                                    nextStop,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.colors.textPrimary),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Arriving in $etaLabel',
                                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: context.colors.chip,
                                        foregroundColor: AppColors.primary,
                                        elevation: 0,
                                      ),
                                      onPressed: () => Navigator.of(context)
                                          .push(slideRoute(BusDetailsScreen(busId: widget.busId))),
                                      child: const Text('View Details'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const DevJumpMenuButton(current: 'Live Tracking'),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  final bool isLive;
  const _LiveBadge({required this.isLive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isLive ? AppColors.success : Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            isLive ? 'LIVE' : 'DEMO',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }
}
