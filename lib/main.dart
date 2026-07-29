import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_runtime.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // This project can be run as a UI demo without Firebase credentials. The
  // Firebase plugins otherwise prevent the app from starting when the native
  // configuration files have not yet been generated with FlutterFire.
  if (AppRuntime.firebaseEnabled) {
    try {
      await Firebase.initializeApp();
      AppRuntime.firebaseAvailable = true;
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'Smart Transit startup',
        context: ErrorDescription('while initializing optional Firebase services'),
      ));
    }
  }
  runApp(const SmartTransitApp());
}

class SmartTransitApp extends StatelessWidget {
  const SmartTransitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Transit Kigali',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
