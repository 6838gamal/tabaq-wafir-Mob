// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color accent = Color(0xFFF97316);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF9C3);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0891B2);
  static const Color infoLight = Color(0xFFE0F2FE);

  // Driver status colours
  static const Color online = Color(0xFF16A34A);
  static const Color offline = Color(0xFF6B7280);
  static const Color busy = Color(0xFFD97706);

  // Light Theme
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textHintLight = Color(0xFF9CA3AF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color iconLight = Color(0xFF6B7280);

  // Dark Theme
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color dividerDark = Color(0xFF374151);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textHintDark = Color(0xFF6B7280);
  static const Color borderDark = Color(0xFF374151);
  static const Color iconDark = Color(0xFF9CA3AF);

  // Map
  static const Color mapRoute = Color(0xFF2563EB);
  static const Color mapPin = Color(0xFFDC2626);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1F2937)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
