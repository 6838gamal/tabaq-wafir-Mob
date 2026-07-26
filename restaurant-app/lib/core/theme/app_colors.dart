import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF3F83F8);
  static const Color primaryDark = Color(0xFF1E429F);
  static const Color secondary = Color(0xFF0E9F6E);
  static const Color secondaryLight = Color(0xFF31C48D);
  static const Color accent = Color(0xFFF05252);
  static const Color warning = Color(0xFFFF8A4C);
  static const Color warningLight = Color(0xFFFFF8F0);
  static const Color success = Color(0xFF0E9F6E);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color error = Color(0xFFF05252);
  static const Color errorLight = Color(0xFFFFF5F5);
  static const Color info = Color(0xFF3F83F8);
  static const Color infoLight = Color(0xFFEBF5FF);

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

  // KPI Colors
  static const Color kpiBlue = Color(0xFF1A56DB);
  static const Color kpiGreen = Color(0xFF0E9F6E);
  static const Color kpiOrange = Color(0xFFFF8A4C);
  static const Color kpiRed = Color(0xFFF05252);
  static const Color kpiPurple = Color(0xFF9061F9);
  static const Color kpiTeal = Color(0xFF0694A2);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF1A56DB),
    Color(0xFF0E9F6E),
    Color(0xFFFF8A4C),
    Color(0xFFF05252),
    Color(0xFF9061F9),
    Color(0xFF0694A2),
    Color(0xFFF6C90E),
  ];

  // Status Colors
  static const Color statusPending = Color(0xFFF6C90E);
  static const Color statusActive = Color(0xFF0E9F6E);
  static const Color statusInactive = Color(0xFF6B7280);
  static const Color statusCancelled = Color(0xFFF05252);
  static const Color statusCompleted = Color(0xFF1A56DB);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A56DB), Color(0xFF3F83F8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1F2937)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
