import 'package:flutter/material.dart';
import '../app_runtime.dart';
import '../services/transit_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/slide_route.dart';
import 'live_tracking_screen.dart';

class SearchRouteScreen extends StatefulWidget {
  const SearchRouteScreen({super.key});

  @override
  State<SearchRouteScreen> createState() => _SearchRouteScreenState();
}

class _SearchRouteScreenState extends State<SearchRouteScreen> {
  bool _searched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        const FadeInUp(
                          child: Text(
                            'Find your Route',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textDark),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FadeInUp(
                          delay: const Duration(milliseconds: 60),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(color: AppColors.cardGrey, borderRadius: BorderRadius.circular(12)),
                            child: const Text(
                              'From: Current Location',
                              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FadeInUp(
                          delay: const Duration(milliseconds: 110),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(color: AppColors.cardGrey, borderRadius: BorderRadius.circular(12)),
                            child: const Text(
                              'To: Select destination',
                              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        FadeInUp(
                          delay: const Duration(milliseconds: 160),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (AppRuntime.firebaseAvailable) {
                                await TransitRepository().createTripRequest(origin: 'Current Location', destination: 'Select destination', routeId: '45');
                              }
                              if (mounted) setState(() => _searched = true);
                            },
                            child: const Text('Find Route'),
                          ),
                        ),
                        const SizedBox(height: 22),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 380),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(
                              scale: Tween(begin: 0.96, end: 1.0).animate(
                                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                              ),
                              child: child,
                            ),
                          ),
                          child: _searched
                              ? GestureDetector(
                                  key: const ValueKey('result'),
                                  onTap: () => Navigator.of(context).push(slideRoute(const LiveTrackingScreen())),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: AppColors.divider),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 6)),
                                      ],
                                    ),
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Route 45', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textDark)),
                                        SizedBox(height: 6),
                                        Text('25 minutes', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                                        Text('12.5 KM', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(key: ValueKey('empty')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DevJumpMenuButton(current: 'Search Route'),
          ],
        ),
      ),
    );
  }
}
