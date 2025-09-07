import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String primaryFontFamily = 'Inter';
  static const String secondaryFontFamily = 'RobotoMono';
  
  // Text Styles
  static const TextStyle h1 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
  );
  
  static const TextStyle h4 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  static const TextStyle h5 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  static const TextStyle button = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle monospace = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  // Themed Text Styles
  static TextStyle get h1Dark => h1.copyWith(color: AppColors.textPrimary);
  static TextStyle get h2Dark => h2.copyWith(color: AppColors.textPrimary);
  static TextStyle get h3Dark => h3.copyWith(color: AppColors.textPrimary);
  static TextStyle get h4Dark => h4.copyWith(color: AppColors.textPrimary);
  static TextStyle get h5Dark => h5.copyWith(color: AppColors.textPrimary);
  static TextStyle get bodyLargeDark => bodyLarge.copyWith(color: AppColors.textPrimary);
  static TextStyle get bodyDark => body.copyWith(color: AppColors.textPrimary);
  static TextStyle get bodySmallDark => bodySmall.copyWith(color: AppColors.textSecondary);
  static TextStyle get captionDark => caption.copyWith(color: AppColors.textTertiary);
  
  static TextStyle get h1Light => h1.copyWith(color: AppColors.white);
  static TextStyle get h2Light => h2.copyWith(color: AppColors.white);
  static TextStyle get h3Light => h3.copyWith(color: AppColors.white);
  static TextStyle get h4Light => h4.copyWith(color: AppColors.white);
  static TextStyle get h5Light => h5.copyWith(color: AppColors.white);
  static TextStyle get bodyLargeLight => bodyLarge.copyWith(color: AppColors.white);
  static TextStyle get bodyLight => body.copyWith(color: AppColors.white);
  static TextStyle get bodySmallLight => bodySmall.copyWith(color: AppColors.white.withOpacity(0.8));
  static TextStyle get captionLight => caption.copyWith(color: AppColors.white.withOpacity(0.6));
}