import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../services/transit_repository.dart';
import '../cubit/settings/settings_cubit.dart';
import '../cubit/settings/settings_state.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/settings_toggle_row.dart';

String _relativeTime(Timestamp? timestamp) {
  if (timestamp == null) return '';
  final diff = DateTime.now().difference(timestamp.toDate());
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: TransitRepository().watchNotifications(),
                          builder: (context, snapshot) {
                            final docs = snapshot.data?.docs ?? const [];
                            if (docs.isEmpty) {
                              return FadeInUp(
                                delay: const Duration(milliseconds: 60),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardGrey,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'No notifications yet. Bus delays and route updates for your saved trips will show up here.',
                                    style: TextStyle(color: AppColors.textGrey, fontSize: 13, height: 1.4),
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children: List.generate(docs.length, (i) {
                                final data = docs[i].data();
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
                                                child: Text(data['title'] as String? ?? '',
                                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark)),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(_relativeTime(data['createdAt'] as Timestamp?),
                                                  style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(data['body'] as String? ?? '',
                                              style: const TextStyle(color: AppColors.textGrey, fontSize: 13, height: 1.4)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
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
