// dart
import 'analysis_model.dart';

class Product {
  final String? id; // UUID from Supabase
  final String title;
  final String description;
  final String? image;
  final String? status;
  final String riskLevel;
  bool isFavorite;
  final DateTime createdAt;
  final List<HarmfulIngredient>? harmfulIngredients;

  Product({
    this.id,
    required this.riskLevel,
    this.isFavorite = false,
    required this.title,
    required this.description,
    this.image,
    this.status,
    DateTime? createdAt,
    this.harmfulIngredients,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    List<HarmfulIngredient>? harmfulIngredientsList;
    // Handle both 'ingredientsList' (from Gemini) and 'ingredients_list' (from Supabase)
    final ingredientsData = json['ingredientsList'] ?? json['ingredients_list'];
    if (ingredientsData != null) {
      harmfulIngredientsList =
          (ingredientsData as List)
              .map(
                (i) => HarmfulIngredient.fromJson(
                  Map<String, dynamic>.from(i as Map),
                ),
              )
              .toList();
    }

    final createdAtValue = json['created_at'];
    DateTime parsedCreatedAt;
    if (createdAtValue == null) {
      parsedCreatedAt = DateTime.now();
    } else if (createdAtValue is int) {
      parsedCreatedAt = DateTime.fromMillisecondsSinceEpoch(createdAtValue);
    } else if (createdAtValue is String) {
      parsedCreatedAt = DateTime.tryParse(createdAtValue) ?? DateTime.now();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return Product(
      id: json['id'] as String?,
      riskLevel: (json['risk_level'] as String?) ?? '',
      isFavorite: (json['is_favorite'] as bool?) ?? false,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      image: json['image'] as String?,
      status: json['status'] as String?,
      harmfulIngredients: harmfulIngredientsList,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'risk_level': riskLevel,
      'is_favorite': isFavorite,
      'title': title,
      'description': description,
      'image': image,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      if (harmfulIngredients != null)
        'ingredientsList': harmfulIngredients!.map((n) => n.toJson()).toList(),
    };
  }
}
