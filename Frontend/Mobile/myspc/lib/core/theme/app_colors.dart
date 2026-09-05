import 'package:flutter/material.dart';

/// MySpc brand color palette — matches the web Tailwind config
class AppColors {
  AppColors._();

  // Primary orange
  static const Color orange = Color(0xFFFF7A00);
  static const Color orangeDark = Color(0xFFE56D00);
  static const Color orangeLight = Color(0xFFFF9533);

  // Orange tints (for focus rings, backgrounds)
  static const Color orange10 = Color(0x1AFF7A00);  // 10% opacity
  static const Color orange20 = Color(0x33FF7A00);  // 20% opacity
  static const Color orange30 = Color(0x4DFF7A00);  // 30% opacity

  // Background / surface
  static const Color cream = Color(0xFFFFF3E8);      // hero background
  static const Color white = Color(0xFFFFFFFF);      // card / form background
  static const Color surface = Color(0xFFFAFAFA);

  // Text
  static const Color text = Color(0xFF1A1A1A);       // myspc-text
  static const Color muted = Color(0xFF6B7280);      // myspc-muted
  static const Color placeholder = Color(0xFFADB5BD);

  // Border
  static const Color border = Color(0xFFE5E7EB);     // myspc-border
  static const Color borderFocused = orange;

  // Semantic
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color success = Color(0xFF16A34A);

  // Status bar / scaffold
  static const Color scaffoldBg = cream;
}
