import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/config/map_api_config.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/pulsing_map_dot.dart';
import '../widgets/slide_route.dart';
import 'bus_details_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  static const _kigaliCentre = LatLng(-1.9441, 30.0619);
  bool _sheetUp = false;

  bool get _mapsSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _sheetUp = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                PillBackButton(onTap: () => Navigator.of(context).pop()),
                Expanded(
                  child: Stack(
                    children: [
                      _mapsSupported
                          ? GoogleMap(
                              initialCameraPosition: const CameraPosition(
                                  target: _kigaliCentre, zoom: 13),
                              markers: {
                                const Marker(
                                  markerId: MarkerId('rider'),
                                  position: _kigaliCentre,
                                  infoWindow:
                                      InfoWindow(title: 'Your location'),
                                ),
                                const Marker(
                                  markerId: MarkerId('next-stop'),
                                  position: LatLng(-1.9396, 30.0588),
                                  infoWindow:
                                      InfoWindow(title: 'Nyabugogo Station'),
                                ),
                              },
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                            )
                          : const _RapidApiStreetView(),
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
                              padding:
                                  const EdgeInsets.fromLTRB(24, 24, 24, 32),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(28)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 24,
                                      offset: Offset(0, -8)),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Next Stop',
                                      style: TextStyle(
                                          color: AppColors.textGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Nyabugogo Station',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Arriving in 8 minutes',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.chipBg,
                                        foregroundColor: AppColors.primary,
                                        elevation: 0,
                                      ),
                                      onPressed: () => Navigator.of(context)
                                          .push(slideRoute(
                                              const BusDetailsScreen())),
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

class _RapidApiStreetView extends StatelessWidget {
  const _RapidApiStreetView();

  static const _streetViewUrl =
      'https://google-map-places.p.rapidapi.com/maps/api/streetview?'
      'size=600x400&source=default&return_error_code=true&location=Kigali%2C%20Rwanda';

  @override
  Widget build(BuildContext context) {
    if (!MapApiConfig.hasRapidApiKey) {
      return Container(
        width: double.infinity,
        color: AppColors.cardGrey,
        child: const Stack(
          children: [
            Center(
              child: Text(
                'Map is available on Android and iOS.\n'
                'Add RAPIDAPI_KEY to show Street View here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PulsingMapDot(),
          ],
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          _streetViewUrl,
          fit: BoxFit.cover,
          headers: const {
            'Content-Type': 'application/json',
            'x-rapidapi-host': MapApiConfig.rapidApiHost,
            'x-rapidapi-key': MapApiConfig.rapidApiKey,
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.cardGrey,
            alignment: Alignment.center,
            child: const Text(
              'Street View is currently unavailable.',
              style: TextStyle(
                color: AppColors.textGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const PulsingMapDot(),
      ],
    );
  }
}
