import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/transit_models.dart';
import '../../services/transit_repository.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/slide_route.dart';
import 'live_tracking_screen.dart';

const _defaultStops = ['Downtown Terminal', 'Nyabugogo', 'Remera', 'Kimironko'];

class BusDetailsScreen extends StatelessWidget {
  final String busId;
  const BusDetailsScreen({super.key, this.busId = kDemoBusId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: TransitRepository().watchBus(busId),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final stops = (data?['stops'] as List?)?.cast<String>() ?? _defaultStops;
        final activeStopIndex = (data?['activeStopIndex'] as num?)?.toInt() ?? 0;
        final occupied = data?['occupied'];
        final capacity = data?['capacity'];
        final capacityLabel = (occupied is num && capacity is num)
            ? '$occupied / $capacity Seats Occupied'
            : '35 / 50 Seats Occupied';
        final fareRwf = data?['fareRwf'];
        final fareLabel = fareRwf is num ? 'Fare: $fareRwf RWF' : 'Fare: 500 RWF';
        final etaMinutes = data?['etaMinutes'];
        final etaLabel = etaMinutes is num ? '$etaMinutes minutes' : '4 minutes';
        final distanceKm = data?['distanceKm'];
        final distanceLabel = distanceKm is num ? '$distanceKm km' : '1.8 km';

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PillBackButton(onTap: () => Navigator.of(context).pop()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInUp(
                              child: Text('Bus Details',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.colors.textPrimary)),
                            ),
                            const SizedBox(height: 18),
                            FadeInUp(
                              delay: const Duration(milliseconds: 60),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: context.colors.divider),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                                ),
                                child: Column(
                                  children: [
                                    _Row(label: 'Bus Number', value: data?['busNumber'] as String? ?? '103'),
                                    const SizedBox(height: 10),
                                    _Row(label: 'Route', value: data?['routeLabel'] as String? ?? 'Downtown Terminal → Kimironko'),
                                    const SizedBox(height: 10),
                                    _Row(label: 'Operator', value: data?['operator'] as String? ?? 'City Transit'),
                                    const SizedBox(height: 10),
                                    _Row(label: 'Status', value: data?['status'] as String? ?? 'On Time', valueColor: AppColors.success),
                                    const SizedBox(height: 10),
                                    _Row(label: 'Capacity', value: capacityLabel),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            FadeInUp(
                              delay: const Duration(milliseconds: 110),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: context.colors.chip, borderRadius: BorderRadius.circular(16)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _Stat(label: 'Next Stop', value: data?['nextStop'] as String? ?? 'Remera'),
                                    _Stat(label: 'Arrival', value: etaLabel, color: AppColors.primary),
                                    _Stat(label: 'Distance', value: distanceLabel),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeInUp(
                              delay: const Duration(milliseconds: 160),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Column(
                                  children: List.generate(stops.length, (i) {
                                    final isActive = i == activeStopIndex;
                                    final isLast = i == stops.length - 1;
                                    return _StopRow(
                                      label: stops[i],
                                      isActive: isActive,
                                      isLast: isLast,
                                      lineDelay: Duration(milliseconds: 200 + i * 140),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            FadeInUp(
                              delay: const Duration(milliseconds: 220),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(fareLabel, style: TextStyle(fontWeight: FontWeight.w700, color: context.colors.textPrimary, fontSize: 13)),
                                    Flexible(
                                      child: Text('Payment: Mobile Money Accepted',
                                          textAlign: TextAlign.right, style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            FadeInUp(
                              delay: const Duration(milliseconds: 260),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: context.colors.divider)),
                                child: Text(
                                    'Driver: ${data?['driverName'] as String? ?? 'Jean Claude'}   '
                                    'Vehicle ID: ${data?['vehicleId'] as String? ?? 'KT-103'}',
                                    style: TextStyle(fontWeight: FontWeight.w600, color: context.colors.textPrimary, fontSize: 13)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeInUp(
                              delay: const Duration(milliseconds: 300),
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).push(slideRoute(LiveTrackingScreen(busId: busId))),
                                child: const Text('View Live Tracking'),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const DevJumpMenuButton(current: 'Bus Details'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _Row({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
        Text(value, style: TextStyle(color: valueColor ?? context.colors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _Stat({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color ?? context.colors.textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
      ],
    );
  }
}

class _StopRow extends StatefulWidget {
  final String label;
  final bool isActive;
  final bool isLast;
  final Duration lineDelay;
  const _StopRow({required this.label, required this.isActive, required this.isLast, required this.lineDelay});

  @override
  State<_StopRow> createState() => _StopRowState();
}

class _StopRowState extends State<_StopRow> with SingleTickerProviderStateMixin {
  bool _grown = false;
  AnimationController? _pulseController;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
    }
    Future.delayed(widget.lineDelay, () {
      if (mounted) setState(() => _grown = true);
    });
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              widget.isActive
                  ? AnimatedBuilder(
                      animation: _pulseController!,
                      builder: (context, child) {
                        final t = _pulseController!.value;
                        return Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.35 * (1 - t)),
                                blurRadius: 6 * t + 2,
                                spreadRadius: 5 * t,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Container(width: 12, height: 12, decoration: BoxDecoration(color: context.colors.divider, shape: BoxShape.circle)),
              if (!widget.isLast)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOut,
                  width: 2,
                  height: _grown ? 34 : 0,
                  color: context.colors.divider,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                color: widget.isActive ? context.colors.textPrimary : context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
