import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for Smart Transit Kigali.
/// Palette pulled from the Figma file: a single confident transit blue,
/// a near-white slate background, and status colors used sparingly
/// (green = on time, amber = SMS/offline fallback, red = errors).
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF3366FF);
  static const Color primaryDark = Color(0xFF2952CC);
  static const Color chipBg = Color(0xFFEAF0FF);

  static const Color bgLight = Color(0xFFF6F7FB);
  static const Color cardGrey = Color(0xFFF2F3F7);
  static const Color divider = Color(0xFFE8EAF0);

  static const Color textDark = Color(0xFF15181F);
  static const Color textBody = Color(0xFF4B5163);
  static const Color textGrey = Color(0xFF9AA1B2);

  static const Color success = Color(0xFF22B573);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFEB4D4D);
  static const Color errorBg = Color(0xFFFDECEC);
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
}
