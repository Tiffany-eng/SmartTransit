import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../cubit/settings/settings_cubit.dart';
import '../cubit/settings/settings_state.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/settings_toggle_row.dart';
import '../widgets/slide_route.dart';
import 'data_settings_screen.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountLinks = [
      'Personal Information',
      'Payment Methods',
      'Saved Stops',
      'Support & Help'
    ];

    final authState = context.watch<AuthCubit>().state;
    final email = authState is Authenticated
        ? (authState.user.email ?? 'No email found')
        : 'No email found';
    // Use the part before "@" as a stand-in display name, since we don't
    // store a separate name field yet.
    final displayName = email.contains('@') ? email.split('@')[0] : email;
    final avatarInitial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PillBackButton(onTap: () => Navigator.of(context).pop()),
                  Center(
                    child: FadeInUp(
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.6, end: 1),
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.elasticOut,
                            builder: (context, scale, child) =>
                                Transform.scale(scale: scale, child: child),
                            child: Container(
                              width: 76,
                              height: 76,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle),
                              child: Text(avatarInitial,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(displayName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: context.colors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(email,
                              style: TextStyle(
                                  color: context.colors.textMuted, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text('Member Since: January 2026',
                              style: TextStyle(
                                  color: context.colors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 80),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: context.colors.chip,
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          children: [
                            Text('Transit Summary',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: context.colors.textPrimary,
                                    fontSize: 14)),
                            const SizedBox(height: 14),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _SummaryStat(
                                    label: 'Trips Completed', value: '48'),
                                _SummaryStat(
                                    label: 'Favorite Route',
                                    value: 'Route 103'),
                                _SummaryStat(
                                    label: 'Monthly Savings',
                                    value: '12,500 RWF'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          delay: const Duration(milliseconds: 120),
                          child: Text('Account',
                              style: TextStyle(
                                  color: context.colors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4)),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(accountLinks.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: FadeInUp(
                              delay: Duration(milliseconds: 150 + i * 40),
                              child: _ProfileRow(
                                  label: accountLinks[i], onTap: () {}),
                            ),
                          );
                        }),
                        const SizedBox(height: 14),
                        FadeInUp(
                          delay: const Duration(milliseconds: 320),
                          child: Text('Preferences',
                              style: TextStyle(
                                  color: context.colors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4)),
                        ),
                        const SizedBox(height: 10),
                        FadeInUp(
                          delay: const Duration(milliseconds: 350),
                          child: _ProfileRow(
                            label: 'Data & Offline SMS Settings',
                            onTap: () => Navigator.of(context)
                                .push(slideRoute(const DataSettingsScreen())),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInUp(
                          delay: const Duration(milliseconds: 390),
                          child: _ProfileRow(
                            label: 'Notifications',
                            onTap: () => Navigator.of(context)
                                .push(slideRoute(const NotificationsScreen())),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInUp(
                          delay: const Duration(milliseconds: 430),
                          child: BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, settingsState) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 15),
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: context.colors.divider),
                                ),
                                child: SettingsToggleRow(
                                  label: 'Dark Mode',
                                  value: settingsState.settings.themeMode ==
                                      ThemeMode.dark,
                                  onChanged: (_) => context
                                      .read<SettingsCubit>()
                                      .toggleThemeMode(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        FadeInUp(
                          delay: const Duration(milliseconds: 480),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.errorBg,
                                  foregroundColor: AppColors.error,
                                  elevation: 0),
                              onPressed: () async {
                                // Actually sign the user out of Firebase first,
                                // then send them back to the Login screen.
                                await context.read<AuthCubit>().signOut();
                                if (!context.mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                    slideRoute(const LoginScreen()),
                                    (route) => false);
                              },
                              child: const Text('Logout'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DevJumpMenuButton(current: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 14)),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ProfileRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                    fontSize: 13.5)),
            Icon(Icons.chevron_right,
                size: 18, color: context.colors.textMuted),
          ],
        ),
      ),
    );
  }
}
