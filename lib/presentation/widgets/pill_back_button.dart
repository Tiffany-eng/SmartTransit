import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// The rounded grey back pill seen at the top of every secondary screen.
class PillBackButton extends StatefulWidget {
  final VoidCallback? onTap;
  const PillBackButton({super.key, this.onTap});

  @override
  State<PillBackButton> createState() => _PillBackButtonState();
}

class _PillBackButtonState extends State<PillBackButton> {
  double _scale = 1;

  void _setScale(double v) => setState(() => _scale = v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTapDown: (_) => _setScale(0.9),
          onTapUp: (_) => _setScale(1),
          onTapCancel: () => _setScale(1),
          onTap: widget.onTap ?? () => Navigator.of(context).maybePop(),
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 120),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.colors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, size: 18, color: context.colors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
