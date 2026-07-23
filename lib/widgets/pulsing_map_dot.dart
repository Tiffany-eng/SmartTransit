import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A "you are here" marker: a solid dot with two expanding, fading rings,
/// looping continuously — used inside the placeholder map areas.
class PulsingMapDot extends StatefulWidget {
  const PulsingMapDot({super.key});

  @override
  State<PulsingMapDot> createState() => _PulsingMapDotState();
}

class _PulsingMapDotState extends State<PulsingMapDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _ring(double phase) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = (_controller.value + phase) % 1.0;
        final scale = 0.6 + t * 3.2;
        final opacity = (1 - t).clamp(0.0, 1.0) * 0.5;
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 70,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _ring(0.0),
            _ring(0.5),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
