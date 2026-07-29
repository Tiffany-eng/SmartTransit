import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Top-right cluster on the Home screens: a gently-ringing notification
/// bell, the "Kigali" location chip, and the user's initials avatar.
class HomeHeaderBar extends StatefulWidget {
  final VoidCallback? onBellTap;
  const HomeHeaderBar({super.key, this.onBellTap});

  @override
  State<HomeHeaderBar> createState() => _HomeHeaderBarState();
}

class _HomeHeaderBarState extends State<HomeHeaderBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 4000))..repeat();

  late final Animation<double> _ring = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 82),
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.16), weight: 3),
    TweenSequenceItem(tween: Tween(begin: -0.16, end: 0.14), weight: 3),
    TweenSequenceItem(tween: Tween(begin: 0.14, end: -0.10), weight: 3),
    TweenSequenceItem(tween: Tween(begin: -0.10, end: 0.0), weight: 9),
  ]).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: widget.onBellTap,
            child: AnimatedBuilder(
              animation: _ring,
              builder: (context, child) => Transform.rotate(angle: _ring.value, child: child),
              child: const Icon(Icons.notifications_none_rounded, size: 22, color: AppColors.textGrey),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Kigali', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                SizedBox(width: 3),
                Icon(Icons.location_on, size: 12, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.textDark, shape: BoxShape.circle),
            child: const Text('KN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
