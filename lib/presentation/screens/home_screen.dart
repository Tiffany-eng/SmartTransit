import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/action_card.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/home_header_bar.dart';
import '../widgets/slide_route.dart';
import 'data_settings_screen.dart';
import 'live_tracking_screen.dart';
import 'notifications_screen.dart';
import 'search_route_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeaderBar(
                    onBellTap: () => Navigator.of(context).push(slideRoute(const NotificationsScreen())),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          child: Text(
                            'Good morning',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: context.colors.textPrimary),
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 40),
                          child: Text('Keyla', style: TextStyle(color: context.colors.textMuted, fontSize: 14)),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 90),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(slideRoute(const SearchRouteScreen())),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: context.colors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Where are you going?',
                                style: TextStyle(color: context.colors.textMuted, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 130),
                          child: ActionCard(
                            label: 'Find Route',
                            onTap: () => Navigator.of(context).push(slideRoute(const SearchRouteScreen())),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FadeInUp(
                          delay: const Duration(milliseconds: 180),
                          child: ActionCard(
                            label: 'Live Map',
                            onTap: () => Navigator.of(context).push(slideRoute(const LiveTrackingScreen())),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FadeInUp(
                          delay: const Duration(milliseconds: 230),
                          child: ActionCard(
                            label: 'Nearby Stops',
                            onTap: () => Navigator.of(context).push(slideRoute(const LiveTrackingScreen())),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 280),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(slideRoute(const DataSettingsScreen())),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text(
                                'Running low on data? Click here to set up automatic SMS sync '
                                'when data is low or offline',
                                style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DevJumpMenuButton(current: 'Home'),
          ],
        ),
      ),
    );
  }
}
