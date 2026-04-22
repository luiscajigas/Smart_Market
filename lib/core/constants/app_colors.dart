import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00C853);
  static const Color primaryDark = Color(0xFF009624);
  static const Color primaryLight = Color(0xFF69F0AE);

  static const Color background = Color(0xFF050505);
  static const Color surface = Color(0xFF0F0F0F);
  static const Color cardBackground = Color(0xFF161616);
  static const Color inputBackground = Color(0xFF1A1A1A);

  static const Color border = Color(0xFF2A2A2A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFF5A5A5A);

  static const Color error = Color(0xFFFF4757);
  static const Color success = Color(0xFF00C853);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C853), Color(0xFF00897B)],
  );
}