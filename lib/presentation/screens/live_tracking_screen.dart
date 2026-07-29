import 'package:flutter/material.dart';
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
  bool _sheetUp = false;

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
                      Container(
                        width: double.infinity,
                        color: AppColors.cardGrey,
                        child: const Stack(
                          children: [
                            Center(
                              child: Text('Map View', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                            ),
                            PulsingMapDot(),
                          ],
                        ),
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
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, -8)),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Next Stop', style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Nyabugogo Station',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Arriving in 8 minute',
                                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14),
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
                                      onPressed: () => Navigator.of(context).push(slideRoute(const BusDetailsScreen())),
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
