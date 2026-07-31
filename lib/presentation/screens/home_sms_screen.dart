import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/action_card.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/home_header_bar.dart';
import '../widgets/slide_route.dart';
import 'notifications_screen.dart';
import 'tracking_sms_screen.dart';

class HomeSmsScreen extends StatefulWidget {
  const HomeSmsScreen({super.key});

  @override
  State<HomeSmsScreen> createState() => _HomeSmsScreenState();
}

class _HomeSmsScreenState extends State<HomeSmsScreen> {
  bool _bannerDown = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _bannerDown = true);
    });
  }

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
                  HomeHeaderBar(onBellTap: () => Navigator.of(context).push(slideRoute(const NotificationsScreen()))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: AnimatedSlide(
                      offset: _bannerDown ? Offset.zero : const Offset(0, -0.6),
                      duration: const Duration(milliseconds: 380),
                      curve: Curves.easeOut,
                      child: AnimatedOpacity(
                        opacity: _bannerDown ? 1 : 0,
                        duration: const Duration(milliseconds: 380),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            'Running via Offline SMS Mode — Data Saved',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          child: Text('Good morning',
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: context.colors.textPrimary)),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 40),
                          child: Text('Keyla', style: TextStyle(color: context.colors.textMuted, fontSize: 14)),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 90),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12)),
                            child: Text('Where are you going?', style: TextStyle(color: context.colors.textMuted, fontSize: 14)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 130),
                          child: ActionCard(
                            label: 'Find Route',
                            muted: true,
                            onTap: () => Navigator.of(context).push(slideRoute(const TrackingSmsScreen())),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FadeInUp(
                          delay: const Duration(milliseconds: 180),
                          child: ActionCard(
                            label: 'Live Map',
                            muted: true,
                            onTap: () => Navigator.of(context).push(slideRoute(const TrackingSmsScreen())),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FadeInUp(
                          delay: const Duration(milliseconds: 230),
                          child: const ActionCard(label: 'Nearby Stops', muted: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DevJumpMenuButton(current: 'Home (SMS Mode)'),
          ],
        ),
      ),
    );
  }
}
