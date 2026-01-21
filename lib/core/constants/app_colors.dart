import 'package:flutter/material.dart';

/// App Colors - Tema Hijau Muslim Daily Style
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2D8659); // Emerald Green
  static const Color primaryDark = Color(0xFF1B5E3F); // Dark Green
  static const Color primaryLight = Color(0xFFE8F5E9); // Very Light Green

  // Secondary/Accent Colors
  static const Color accent = Color(0xFFFFA500); // Orange/Gold accent
  static const Color accentLight = Color(0xFFFFE8CC);

  // Background Colors
  static const Color background = Color(0xFFF0F5F2); // Soft Green-Gray
  static const Color cardBackground = Color(0xFFFFFFFF); // White

  // Text Colors
  static const Color textPrimary = Color(0xFF1B1B1B); // Dark text
  static const Color textSecondary = Color(0xFF757575); // Medium gray
  static const Color textHint = Color(0xFFBDBDBD); // Light gray

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
