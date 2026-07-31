import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/slide_route.dart';
import 'home_sms_screen.dart';

class RouteErrorScreen extends StatefulWidget {
  const RouteErrorScreen({super.key});

  @override
  State<RouteErrorScreen> createState() => _RouteErrorScreenState();
}

class _RouteErrorScreenState extends State<RouteErrorScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  late final Animation<double> _shake = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 6.0, end: -4.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 1),
  ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 480), () {
      if (mounted) _shakeController.forward();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
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
                  PillBackButton(onTap: () => Navigator.of(context).pop()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          child: Text('Error State: Connection Lost',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: context.colors.textPrimary)),
                        ),
                        const SizedBox(height: 44),
                        FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: AnimatedBuilder(
                            animation: _shake,
                            builder: (context, child) => Transform.translate(offset: Offset(_shake.value, 0), child: child),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                              decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: const [
                                  Icon(Icons.error_outline_rounded, color: AppColors.error, size: 30),
                                  SizedBox(height: 12),
                                  Text(
                                    'Unable to retrieve real-time transit databases due to network '
                                    'connection interruption.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700, fontSize: 14, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FadeInUp(
                          delay: const Duration(milliseconds: 180),
                          child: ElevatedButton(onPressed: () {}, child: const Text('Retry Search Connection')),
                        ),
                        const SizedBox(height: 12),
                        FadeInUp(
                          delay: const Duration(milliseconds: 230),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(slideRoute(const HomeSmsScreen()));
                            },
                            child: const Text('Switch to Offline SMS Mode'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DevJumpMenuButton(current: 'Route Error'),
          ],
        ),
      ),
    );
  }
}
