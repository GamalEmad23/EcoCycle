import 'package:flutter/material.dart';

class AppColors {
  static bool isDarkMode = false;

  // Primary - Vibrant greens look great on dark backgrounds too
  static Color get primary => const Color(0xFF18C24E);
  static Color get primaryLight => const Color(0xFF1ED760);
  static Color get primaryDark => const Color(0xFF16A34A);
  static Color get green => const Color(0xFF22C55E);
  static Color get Textcolor => const Color(0xff0FE621);

  // Light Greens - In dark mode, we use very subtle and elegant tinted backgrounds
  static Color get lightGreen1 => isDarkMode ? const Color(0xFF11291B) : const Color(0xFFA7F3D0);
  static Color get lightGreen2 => isDarkMode ? const Color(0xFF163825) : const Color(0xFFBBF7D0);
  static Color get lightGreen3 => isDarkMode ? const Color(0xFF0C1F14) : const Color(0xFFDCFCE7);
  static Color get lightGreen4 => isDarkMode ? const Color(0xFF1B472F) : const Color(0xFF86EFAC);
  static Color get lightGreen5 => isDarkMode ? const Color(0x3318C24E) : const Color(0x330FE621);

  // Backgrounds - Ultra Premium Dark Mode: Very deep, rich, barely-green dark slate.
  // This makes the green accents POP brilliantly while keeping it easy on the eyes.
  static Color get white => isDarkMode ? const Color(0xFF141A16) : const Color(0xFFFFFFFF); // Surfaces & Cards
  static Color get background => isDarkMode ? const Color(0xFF0A0D0B) : const Color(0xFFF8FAF9); // Main Scaffold
  static Color get backgroundLight => isDarkMode ? const Color(0xFF1A231D) : const Color(0xFFF3F4F6); // Lighter sections
  static Color get border => isDarkMode ? const Color(0xFF233027) : const Color(0xFFE5E7EB); // Dividers
  static Color get lightWight => isDarkMode ? const Color(0xFF141A16) : const Color(0xFFF3F6F9);

  // Text - High contrast off-whites for maximum readability
  static Color get black => isDarkMode ? const Color(0xFFF9FAFB) : const Color(0xFF000000); // Headings
  static Color get lightGrey => isDarkMode ? const Color(0xFF233027) : const Color(0xFFF5F5F5); // Tooltips / minor bgs
  static Color get textPrimary => isDarkMode ? const Color(0xFFF3F4F6) : const Color(0xFF111827); // Standard text
  static Color get textSecondary => isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF374151); // Subtitles
  static Color get textGrey => isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  static Color get textLight => isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);
  static Color get circleLight => isDarkMode ? const Color(0xFF1A231D) : const Color(0xFFF6F8F6);

  // Accent Colors
  static Color get orange => const Color(0xFFF59E0B);
  static Color get red => const Color(0xFFEF4444);
  static Color get lightRed => isDarkMode ? const Color(0xFF3B1515) : const Color(0xFFFECACA);
  static Color get lime => const Color(0xFF84CC16);
  static Color get olive => const Color(0xFF65A30D);
  static Color get lightGreen => const Color(0xFF14FF72);

  // Home Screen Specific
  // Keeping gradients energetic but not blinding in dark mode
  static Color get levelCardStart => isDarkMode ? const Color(0xFF14A346) : const Color(0xFF07E361);
  static Color get levelCardEnd => isDarkMode ? const Color(0xFF0E7A32) : const Color(0xFF16B34A);
  static Color get actionButtonGray => isDarkMode ? const Color(0xFF1A231D) : const Color(0xFFF1F5F9);
  static Color get tipCardBg => isDarkMode ? const Color(0xFF0E1A13) : const Color(0xFFE6F9EE);
  static Color get iconBgLight => isDarkMode ? const Color(0xFF10212E) : const Color(0xFFE0F2FE);
}
