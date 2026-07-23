import 'package:flutter/material.dart';

/// Pushes [page] with a slide+fade transition, mirroring how the prototype
/// moves between screens. Set [reverse] to true for "back" style navigation
/// (slides in from the left instead of the right).
Route<T> slideRoute<T>(Widget page, {bool reverse = false}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, animation, __) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final offsetTween = Tween<Offset>(
        begin: reverse ? const Offset(-0.06, 0) : const Offset(0.06, 0),
        end: Offset.zero,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(position: offsetTween.animate(curved), child: child),
      );
    },
  );
}
