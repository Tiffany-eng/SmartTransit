import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/slide_route.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late final AnimationController _dotsController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200))
    ..repeat();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 60), () {
      if (mounted) setState(() => _visible = true);
    });
    Future.delayed(const Duration(milliseconds: 2100), () {
      if (!mounted) return;
      // Check if Firebase already has a logged-in user saved on this device.
      final user = AuthService().currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacement(slideRoute(const HomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(slideRoute(const LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  Widget _dot(int index) {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        final t = ((_dotsController.value - index * 0.15) % 1.0 + 1.0) % 1.0;
        final opacity = 0.3 + 0.7 * (1 - (t - 0.4).abs() * 2).clamp(0.0, 1.0);
        return Opacity(opacity: opacity, child: child);
      },
      child: Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              child: AnimatedScale(
                scale: _visible ? 1 : 0.9,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                child: const Text(
                  'SMART TRANSIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              child: Text(
                'Your smart way to move',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.85), fontSize: 14),
              ),
            ),
            const SizedBox(height: 40),
            AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 700),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, _dot)),
            ),
          ],
        ),
      ),
    );
  }
}
