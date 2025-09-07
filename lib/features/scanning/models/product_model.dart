class ProductModel {
  final String id;
  final String barcode;
  final String name;
  final String? brand;
  final String? category;
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> additives;
  final String riskLevel;
  final Map<String, String> nutritionalInfo;
  
  ProductModel({
    required this.id,
    required this.barcode,
    required this.name,
    this.brand,
    this.category,
    this.imageUrl,
    required this.ingredients,
    required this.additives,
    required this.riskLevel,
    required this.nutritionalInfo,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      barcode: json['barcode'] ?? '',
      name: json['name'] ?? 'Unknown Product',
      brand: json['brand'],
      category: json['category'],
      imageUrl: json['image_url'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      additives: List<String>.from(json['additives'] ?? []),
      riskLevel: json['risk_level'] ?? 'unknown',
      nutritionalInfo: Map<String, String>.from(json['nutritional_info'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'category': category,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'additives': additives,
      'risk_level': riskLevel,
      'nutritional_info': nutritionalInfo,
    };
  }
  
  String calculateRiskLevel(List<String> avoidList) {
    // Check if any additives are in the user's avoid list
    final hasAvoidedAdditives = additives.any((additive) => avoidList.contains(additive));
    if (hasAvoidedAdditives) return 'high';
    
    // Calculate based on additive risk levels
    // This is a simplified calculation - in a real app, you'd check each additive's risk
    if (additives.any((a) => a.startsWith('E1') || a.startsWith('E2'))) {
      return 'high';
    } else if (additives.any((a) => a.startsWith('E6') || a.startsWith('E9'))) {
      return 'medium';
    } else if (additives.isEmpty) {
      return 'low';
    }
    
    return 'medium';
  }
}