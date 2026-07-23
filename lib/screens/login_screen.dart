import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/slide_route.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 56),
              const FadeInUp(
                delay: Duration(milliseconds: 40),
                child: Text(
                  'Welcome  back',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: const TextField(decoration: InputDecoration(hintText: 'Email')),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 160),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 220),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(slideRoute(const HomeScreen()));
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 28),
              const FadeInUp(
                delay: Duration(milliseconds: 280),
                child: Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              const FadeInUp(
                delay: Duration(milliseconds: 320),
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: AppColors.textBody, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Create account',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
