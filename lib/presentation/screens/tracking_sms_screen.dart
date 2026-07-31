import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/pulsing_map_dot.dart';
import '../widgets/slide_route.dart';
import 'home_screen.dart';

class TrackingSmsScreen extends StatefulWidget {
  const TrackingSmsScreen({super.key});

  @override
  State<TrackingSmsScreen> createState() => _TrackingSmsScreenState();
}

class _TrackingSmsScreenState extends State<TrackingSmsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PillBackButton(onTap: () => Navigator.of(context).pop()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: AppColors.cardGrey, borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.textGrey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: AppColors.textGrey, fontSize: 12, height: 1.5),
                                      children: [
                                        const TextSpan(
                                            text: 'Last known GPS location queried via automated SMS background text sync '),
                                        WidgetSpan(
                                          child: FadeTransition(
                                            opacity: Tween(begin: 0.4, end: 1.0).animate(_blinkController),
                                            child: const Text('45 seconds ago',
                                                style: TextStyle(color: AppColors.textBody, fontWeight: FontWeight.w700, fontSize: 12)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -6),
                          child: FadeInUp(
                            delay: const Duration(milliseconds: 80),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Route 213F (Kimironko → Nyabugogo)',
                                      style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textDark, fontSize: 13.5)),
                                  SizedBox(height: 8),
                                  Text(
                                    'Estimated Arrival: 6 Mins Out from Remera Stop\nCurrent Bus Capacity Load: 31/50 Seats Occupied',
                                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13, height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: FadeInUp(
                            delay: const Duration(milliseconds: 140),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: AppColors.cardGrey, borderRadius: BorderRadius.circular(20)),
                              child: const Stack(children: [PulsingMapDot()]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          delay: const Duration(milliseconds: 180),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(slideRoute(const HomeScreen()), (route) => false);
                            },
                            child: const Text('Exit Offline Mode'),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const DevJumpMenuButton(current: 'Tracking (SMS Sync)'),
          ],
        ),
      ),
    );
  }
}
