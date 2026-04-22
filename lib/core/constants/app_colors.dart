import 'package:flutter/material.dart';

class AppColors {
  // Primary Green Colors (for Dark Mode)
  static const Color primaryGreen = Color(0xFF00C853);
  static const Color primaryGreenDark = Color(0xFF00A344);
  static const Color primaryGreenLight = Color(0xFF33D375);

  // Primary Blue Colors (for Light Mode)
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryBlueDark = Color(0xFF1976D2);
  static const Color primaryBlueLight = Color(0xFFBBDEFB);

  // Default Primary (for compatibility, will use Theme.of(context).primaryColor mostly)
  static const Color primary = primaryGreen;

  // Dark Mode Colors
  static const Color background = Color(0xFF050505);
  static const Color surface = Color(0xFF0F0F0F);
  static const Color cardBackground = Color(0xFF161616);
  static const Color inputBackground = Color(0xFF1A1A1A);
  static const Color border = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFF5A5A5A);

  // Light Mode Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardBackgroundLight = Color(0xFFFFFFFF);
  static const Color inputBackgroundLight = Color(0xFFF1F3F4);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color textPrimaryLight = Color(0xFF202124);
  static const Color textSecondaryLight = Color(0xFF5F6368);
  static const Color textHintLight = Color(0xFF9AA0A6);

  static const Color error = Color(0xFFFF4757);
  static const Color success = Color(0xFF2196F3);

  static const LinearGradient primaryGradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C853), Color(0xFF009624)],
  );

  static const LinearGradient primaryGradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
  );

  static const LinearGradient primaryGradient = primaryGradientGreen;
}
