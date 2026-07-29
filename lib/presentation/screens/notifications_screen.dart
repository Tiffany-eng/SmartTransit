import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../cubit/settings/settings_cubit.dart';
import '../cubit/settings/settings_state.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/settings_toggle_row.dart';

class _Notification {
  final String title;
  final String body;
  final String time;
  const _Notification(this.title, this.body, this.time);
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _items = [
    _Notification('Bus 103 is arriving soon',
        'Your bus will arrive at Kimironko Stop in approximately 4 minutes.', '2 min ago'),
    _Notification('📍 Route Updated',
        'Traffic congestion detected. Arrival time increased by 3 minutes.', '15 min ago'),
    _Notification('Bus Departed', 'Bus 214 has departed from Nyabugogo Terminal.', '22 min ago'),
    _Notification('⭐ Favorite Route Reminder', 'Your frequently used route is currently active.', '1 hour ago'),
    _Notification('Service Alert', 'Temporary stop closure at Remera due to road maintenance.', '2 hours ago'),
  ];

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
                          child: Text('Notifications',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                        ),
                        const SizedBox(height: 18),
                        FadeInUp(
                          delay: const Duration(milliseconds: 30),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: BlocBuilder<SettingsCubit, SettingsState>(
                              builder: (context, state) {
                                return SettingsToggleRow(
                                  label: 'Push Notifications',
                                  value: state.settings.notificationsEnabled,
                                  onChanged: (_) =>
                                      context.read<SettingsCubit>().toggleNotifications(),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        ...List.generate(_items.length, (i) {
                          final n = _items[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FadeInUp(
                              delay: Duration(milliseconds: 60 + i * 60),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.divider),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(n.title,
                                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark)),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(n.time, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(n.body, style: const TextStyle(color: AppColors.textGrey, fontSize: 13, height: 1.4)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DevJumpMenuButton(current: 'Notifications'),
          ],
        ),
      ),
    );
  }
}
