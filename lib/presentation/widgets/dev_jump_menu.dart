import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_route_screen.dart';
import '../screens/live_tracking_screen.dart';
import '../screens/bus_details_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/data_settings_screen.dart';
import '../screens/route_error_screen.dart';
import '../screens/home_sms_screen.dart';
import '../screens/tracking_sms_screen.dart';

/// A small floating button (top-right of every screen) that opens a sheet
/// listing all 12 screens in the app, for quickly demoing/grading each
/// state without replaying the whole user flow. Purely a dev/demo aid —
/// safe to delete this file (and its usages) for a production build.
class DevJumpMenuButton extends StatelessWidget {
  final String current;
  const DevJumpMenuButton({super.key, required this.current});

  static final Map<String, WidgetBuilder> _screens = {
    'Splash': (_) => const SplashScreen(),
    'Login': (_) => const LoginScreen(),
    'Home': (_) => const HomeScreen(),
    'Search Route': (_) => const SearchRouteScreen(),
    'Live Tracking': (_) => const LiveTrackingScreen(),
    'Bus Details': (_) => const BusDetailsScreen(),
    'Notifications': (_) => const NotificationsScreen(),
    'Profile': (_) => const ProfileScreen(),
    'Data & Offline SMS': (_) => const DataSettingsScreen(),
    'Route Error': (_) => const RouteErrorScreen(),
    'Home (SMS Mode)': (_) => const HomeSmsScreen(),
    'Tracking (SMS Sync)': (_) => const TrackingSmsScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6,
      right: 12,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => _openMenu(context),
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
            ),
            child: const Icon(Icons.apps_rounded, size: 18, color: AppColors.textGrey),
          ),
        ),
      ),
    );
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('JUMP TO SCREEN',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: AppColors.textGrey)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _screens.entries.map((entry) {
                  final active = entry.key == current;
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: entry.value));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.cardGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: active ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
