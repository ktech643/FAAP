import 'package:flutter/material.dart';
import '../UI Helper/colors.dart';

class HarmfulIngredient {
  final String ingredientName;
  final String risk;
  final String risk_level;

  HarmfulIngredient({
    required this.ingredientName,
    required this.risk,
    required this.risk_level,
  });

  factory HarmfulIngredient.fromJson(Map<String, dynamic> json) =>
      HarmfulIngredient(
        ingredientName: json["ingredientName"] ?? "Unknown Ingredient",
        risk: json["risk"] ?? "No risk information available.",
        risk_level: json["risk_level"] ?? "Unknown",
      );

  Map<String, dynamic> toJson() {
    return {
      'ingredientName': ingredientName,
      'risk': risk,
      'risk_level': risk_level,
    };
  }

  Color getStatusColor() {
    switch (risk_level.toLowerCase()) {
      case 'high_risk':
      case 'high':
        return AppColors.textPrimary;
      case 'moderate_risk':
      case 'moderate':
        return AppColors.secondary;
      case 'low_risk':
      case 'low':
        return AppColors.disabled;
      case 'safe':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  Color getBackgroundColor() {
    switch (risk_level.toLowerCase()) {
      case 'safe':
        return AppColors.primary.withOpacity(0.1);
      case 'low':
      case 'low_risk':
        return AppColors.greyVeryLight;
      case 'moderate':
      case 'moderate_risk':
        return AppColors.greyLight;
      case 'high':
      case 'high_risk':
        return AppColors.background;
      default:
        return AppColors.greyVeryLight;
    }
  }

  IconData getStatusIcon() {
    switch (risk_level.toLowerCase()) {
      case 'high_risk':
      case 'high':
        return Icons.warning;
      case 'moderate_risk':
      case 'moderate':
        return Icons.info;
      case 'low_risk':
      case 'low':
        return Icons.check_circle;
      case 'safe':
        return Icons.health_and_safety;
      default:
        return Icons.help;
    }
  }

  String getRiskLevelDisplay() {
    switch (risk_level.toLowerCase()) {
      case 'high_risk':
      case 'high':
        return 'High Risk';
      case 'moderate_risk':
      case 'moderate':
        return 'Moderate Risk';
      case 'low_risk':
      case 'low':
        return 'Low Risk';
      case 'safe':
        return 'Safe';
      default:
        return 'Unknown Risk Level';
    }
  }
}
