import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFFF5722);
  static const Color primaryLight = Color(0xFFFF7043);
  static const Color primaryDark = Color(0xFFE64A19);
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryLight = Color(0xFF66BB6A);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFF8F0);
  static const Color error = Color(0xFFB00020);
  static const Color errorLight = Color(0xFFFFF5F5);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFEBF5FF);

  // Light Theme
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFEEEEEE);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textHintLight = Color(0xFFBDBDBD);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color iconLight = Color(0xFF757575);

  // Dark Theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color dividerDark = Color(0xFF373737);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color textHintDark = Color(0xFF616161);
  static const Color borderDark = Color(0xFF424242);
  static const Color iconDark = Color(0xFF9E9E9E);

  // Status
  static const Color ratingGold = Color(0xFFFFC107);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF5722), Color(0xFFFF7043)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
