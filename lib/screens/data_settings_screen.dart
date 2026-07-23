import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';

class DataSettingsScreen extends StatefulWidget {
  const DataSettingsScreen({super.key});

  @override
  State<DataSettingsScreen> createState() => _DataSettingsScreenState();
}

class _DataSettingsScreenState extends State<DataSettingsScreen> {
  bool _enabled = true;

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
                            'Data & Sync Preferences',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark),
                          ),
                        ),
                        const SizedBox(height: 32),
                        FadeInUp(
                          delay: const Duration(milliseconds: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Enable Automatic SMS Fallback',
                                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark, fontSize: 14)),
                              GestureDetector(
                                onTap: () => setState(() => _enabled = !_enabled),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 260),
                                  curve: Curves.easeOut,
                                  width: 48,
                                  height: 28,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: _enabled ? AppColors.primary : AppColors.divider,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: AnimatedAlign(
                                    duration: const Duration(milliseconds: 260),
                                    curve: Curves.easeOut,
                                    alignment: _enabled ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          delay: const Duration(milliseconds: 110),
                          child: const Text(
                            'When active, Smart Transit automatically switches to a background '
                            'SMS cellular network protocol to pull live bus tracking routes and '
                            'estimated time metrics if mobile data drops. This process operates '
                            'at zero internet data cost.',
                            style: TextStyle(color: AppColors.textGrey, fontSize: 13.5, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DevJumpMenuButton(current: 'Data & Offline SMS'),
          ],
        ),
      ),
    );
  }
}
