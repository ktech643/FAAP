import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color primaryYellow = Color(0xFFFBC02D);
  
  // Secondary Palette
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);
  
  // Neutral Palette
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);
  static const Color black = Color(0xFF000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, Color(0xFF43A047)],
  );
  
  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, Color(0xFFE53935)],
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryYellow, Color(0xFFFFD54F)],
  );
  
  // Risk Level Colors
  static Color getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return primaryRed;
      case 'medium':
        return primaryYellow;
      case 'low':
        return primaryGreen;
      default:
        return gray500;
    }
  }
  
  // Background Colors
  static const Color backgroundPrimary = white;
  static const Color backgroundSecondary = gray50;
  static const Color backgroundTertiary = gray100;
  
  // Text Colors
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray700;
  static const Color textTertiary = gray500;
  static const Color textOnPrimary = white;
  
  // Border Colors
  static const Color borderLight = gray300;
  static const Color borderMedium = gray400;
  static const Color borderDark = gray600;
  
  // Shadow Colors
  static Color shadowLight = black.withOpacity(0.05);
  static Color shadowMedium = black.withOpacity(0.1);
  static Color shadowDark = black.withOpacity(0.2);
}