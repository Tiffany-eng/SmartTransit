import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension AppColorsContext on BuildContext {
  AppSemanticColors get colors => Theme.of(this).extension<AppSemanticColors>()!;
}

/// Design tokens for Smart Transit Kigali.
/// Palette pulled from the Figma file: a single confident transit blue,
/// a near-white slate background, and status colors used sparingly
/// (green = on time, amber = SMS/offline fallback, red = errors).
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF3B6FF5);
  static const Color primaryDark = Color(0xFF2C56C4);
  static const Color chipBg = Color(0xFFEDF2FF);

  static const Color bgLight = Color(0xFFF7F8FC);
  static const Color cardGrey = Color(0xFFF2F4F8);
  static const Color divider = Color(0xFFE7EAF1);

  static const Color textDark = Color(0xFF16181F);
  static const Color textBody = Color(0xFF4B5163);
  static const Color textGrey = Color(0xFF98A0B2);

  static const Color success = Color(0xFF1FAE74);
  static const Color warning = Color(0xFFF2A93B);
  static const Color error = Color(0xFFEA4C4C);
  static const Color errorBg = Color(0xFFFCEDED);
}

/// Colors that need to flip between light and dark mode. `AppColors` stays
/// the fixed brand/status palette (primary blue, success/warning/error);
/// this covers the neutrals -- backgrounds, dividers, body text -- that a
/// dark theme actually needs to invert.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.surface,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.chip,
  });

  final Color surface;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color chip;

  static const light = AppSemanticColors(
    surface: AppColors.cardGrey,
    divider: AppColors.divider,
    textPrimary: AppColors.textDark,
    textSecondary: AppColors.textBody,
    textMuted: AppColors.textGrey,
    chip: AppColors.chipBg,
  );

  static const dark = AppSemanticColors(
    surface: Color(0xFF1C1E26),
    divider: Color(0xFF2C2F3A),
    textPrimary: Color(0xFFF2F3F7),
    textSecondary: Color(0xFFC3C7D6),
    textMuted: Color(0xFF8A8FA3),
    chip: Color(0xFF232640),
  );

  @override
  AppSemanticColors copyWith({
    Color? surface,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? chip,
  }) {
    return AppSemanticColors(
      surface: surface ?? this.surface,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      chip: chip ?? this.chip,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      surface: Color.lerp(surface, other.surface, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      chip: Color.lerp(chip, other.chip, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      extensions: const [AppSemanticColors.light],
    );

    return base.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.primary, width: 1.4),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 14),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121317),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
      extensions: const [AppSemanticColors.dark],
    );

    return base.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.primary, width: 1.4),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E2027),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 14),
      ),
    );
  }
}
