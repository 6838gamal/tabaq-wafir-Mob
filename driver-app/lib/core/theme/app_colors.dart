// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2563EB);      // Blue-600
  static const Color primaryDark = Color(0xFF1D4ED8);  // Blue-700
  static const Color primaryLight = Color(0xFF3B82F6); // Blue-500
  static const Color accent = Color(0xFFF97316);       // Orange-500

  // Status
  static const Color success = Color(0xFF16A34A);  // Green-600
  static const Color warning = Color(0xFFD97706);  // Amber-600
  static const Color error = Color(0xFFDC2626);    // Red-600
  static const Color info = Color(0xFF0891B2);     // Cyan-600

  // Driver status colours
  static const Color online = Color(0xFF16A34A);
  static const Color offline = Color(0xFF6B7280);
  static const Color busy = Color(0xFFD97706);

  // Neutrals
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;

  // Map
  static const Color mapRoute = Color(0xFF2563EB);
  static const Color mapPin = Color(0xFFDC2626);
}
