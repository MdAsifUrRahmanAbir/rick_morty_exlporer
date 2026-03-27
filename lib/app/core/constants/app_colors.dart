import 'package:flutter/material.dart';

class AppColors {
  // --------------------
  // Brand / Portal Colors
  // --------------------
  // Primary green like the portal
  // Modern Brand Colors
  static const Color primary = Color(0xFF6750A4);
  static const Color primaryDark = Color(0xFF4F378B);
  static const Color primaryLight = Color(0xFFEADDFF);
  static const Color onPrimary = Colors.white;
  static const Color secondary = Color(0xFF625B71);
  static const Color tertiary = Color(0xFF7D5260);
  
  // Rick & Morty Palette (Preserved but modernized)
  static const Color portalGreen = Color(0xFF98CA4E);
  static const Color rickCyan = Color(0xFFA6CDC6);
  static const Color mortyYellow = Color(0xFFFAE04D);

  // --------------------
  // Background / Scaffold
  // --------------------
  static const Color scaffoldBackground = Color(0xFFF5F6FA);
  static const Color cardBackground = Colors.white;
  static const Color darkScaffoldBackground = Color(0xFF141414);
  static const Color darkCardBackground = Color(0xFF202022);

  // --------------------
  // Text Colors
  // --------------------
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textLight = Colors.white;

  // --------------------
  // Status Colors
  // --------------------
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // --------------------
  // Grey Shades
  // --------------------
  static const Color greyLight = Color(0xFFEEEEEE);
  static const Color grey = Color(0xFFBDBDBD);
  static const Color greyDark = Color(0xFF616161);

  // --------------------
  // Optional Semantic / Extra
  // --------------------
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x29000000);
  static const Color transparent = Colors.transparent;

  // --------------------
  // Dynamic Theme Colors (for AppTheme)
  // --------------------
  static Color background(bool isDark) =>
      isDark ? darkScaffoldBackground : scaffoldBackground;

  static Color card(bool isDark) =>
      isDark ? darkCardBackground : cardBackground;

  static Color textPrimaryColor(bool isDark) =>
      isDark ? Colors.white : textPrimary;

  static Color textSecondaryColor(bool isDark) =>
      isDark ? greyLight : textSecondary;
}
