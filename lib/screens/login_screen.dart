import 'package:flutter/material.dart';
import '../app_runtime.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/slide_route.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      if (AppRuntime.firebaseAvailable) {
        await AuthService().signIn(_email.text, _password.text);
      }
      if (mounted) Navigator.of(context).pushReplacement(slideRoute(const HomeScreen()));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
                child: TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Email')),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 160),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 220),
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: Text(_loading ? 'Logging in...' : 'Login'),
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
