import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// "Find Route" / "Live Map" / "Nearby Stops" style card with a tiny
/// press-scale for tactile feedback.
class ActionCard extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool muted;

  const ActionCard({super.key, required this.label, this.onTap, this.muted = false});

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1),
      onTapCancel: () => setState(() => _scale = 1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.muted ? AppColors.cardGrey : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: widget.muted ? null : Border.all(color: AppColors.divider),
            boxShadow: widget.muted
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: widget.muted ? AppColors.textGrey : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
