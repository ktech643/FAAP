import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  // Light shadows for cards and elevated surfaces
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  // Medium shadows for floating elements
  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  // Strong shadows for modals and dialogs
  static List<BoxShadow> modalShadow = [
    BoxShadow(
      color: AppColors.shadowDark,
      offset: const Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: const Offset(0, 16),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];
  
  // Subtle shadow for buttons
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  
  // No shadow
  static const List<BoxShadow> none = [];
  
  // Custom elevation shadows
  static List<BoxShadow> elevation(double elevation) {
    if (elevation <= 0) return none;
    
    final double opacity = (elevation / 24).clamp(0.0, 0.2);
    final double blur = elevation * 2;
    final double spread = elevation * 0.5;
    
    return [
      BoxShadow(
        color: AppColors.black.withOpacity(opacity),
        offset: Offset(0, elevation),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }
}