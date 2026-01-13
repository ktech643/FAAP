import 'dart:convert';

import 'package:flutter/material.dart';

FoodProductAnalysis foodProductAnalysisFromJson(String str) {
  final cleanedJson =
      str.replaceAll('```json', '').replaceAll('```', '').trim();
  return FoodProductAnalysis.fromJson(json.decode(cleanedJson));
}

class FoodProductAnalysis {
  final String name;
  final String description;
  final String risk_level;
  final List<HarmfulIngredient> ingredientsList;
  final String? image;

  FoodProductAnalysis({
    required this.name,
    required this.description,
    required this.risk_level,
    required this.ingredientsList,
    this.image,
  });

  factory FoodProductAnalysis.fromJson(Map<String, dynamic> json) {
    return FoodProductAnalysis(
      name: json["name"] ?? "Unknown Product",
      description: json["description"] ?? "No description available.",
      risk_level: json["risk_level"] ?? "Unknown",
      ingredientsList:
          json["ingredientsList"] == null
              ? []
              : List<HarmfulIngredient>.from(
                json["ingredientsList"].map(
                  (x) => HarmfulIngredient.fromJson(x),
                ),
              ),
      image: json["image"],
    );
  }
}

// 👇 THIS CLASS IS UPDATED
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

  // Convert this model back into JSON so callers (e.g. Product.toJson)
  // can serialize lists of HarmfulIngredient objects.
  Map<String, dynamic> toJson() {
    return {
      'ingredientName': ingredientName,
      'risk': risk,
      'risk_level': risk_level,
    };
  }

  Color getStatusColor() {
    switch (risk_level.toLowerCase()) {
      case 'safe':
        return Colors.green;
      case 'low':
        return Colors.orange;
      case 'moderate':
        return Colors.orange[700]!;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getBackgroundColor() {
    switch (risk_level.toLowerCase()) {
      case 'safe':
        return const Color(0xFFDCFCE7); // green-100
      case 'low':
        return const Color(0xFFFEF3C7); // amber-100
      case 'moderate':
        return const Color(0xFFFEF3C7); // amber-100
      case 'high':
        return const Color(0xFFFEE2E2); // red-100
      default:
        return Colors.grey.shade100;
    }
  }

  IconData getStatusIcon() {
    switch (risk_level.toLowerCase()) {
      case 'safe':
        return Icons.health_and_safety;
      case 'low':
        return Icons.error_outline;
      case 'moderate':
        return Icons.warning;
      case 'high':
        return Icons.dangerous;
      default:
        return Icons.info;
    }
  }

  String getRiskLevelDisplay() {
    switch (risk_level.toLowerCase()) {
      case 'safe':
        return 'Safe to Consume';
      case 'low':
        return 'Low Risk';
      case 'moderate':
        return 'Moderate Risk';
      case 'high':
        return 'High Risk';
      default:
        return 'Unknown Risk';
    }
  }
}
