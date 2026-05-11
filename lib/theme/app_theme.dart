import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF5B2D8E);
  static const Color primaryDark = Color(0xFF3D1A6E);
  static const Color primaryLight = Color(0xFF7C3AED);
  static const Color primarySurface = Color(0xFFF3E8FF);
  static const Color green = Color(0xFF16A34A);
  static const Color greenLight = Color(0xFFDCFCE7);
  static const Color orange = Color(0xFFEA580C);
  static const Color orangeLight = Color(0xFFFFF7ED);
  static const Color red = Color(0xFFDC2626);
  static const Color redLight = Color(0xFFFEE2E2);
  static const Color textDark = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F7FF);
  static const Color cardBg = Color(0xFFFFFFFF);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: background,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          backgroundColor: white,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: textDark),
          titleTextStyle: GoogleFonts.poppins(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
      );

  static BoxDecoration get card => BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
