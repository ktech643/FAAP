class AdditiveModel {
  final int? id;
  final String code;
  final String name;
  final String? description;
  final String riskLevel;
  final List<String> healthImpacts;
  final List<String> commonProducts;
  final List<String> alternatives;
  
  AdditiveModel({
    this.id,
    required this.code,
    required this.name,
    this.description,
    required this.riskLevel,
    required this.healthImpacts,
    required this.commonProducts,
    required this.alternatives,
  });
  
  factory AdditiveModel.fromMap(Map<String, dynamic> map) {
    return AdditiveModel(
      id: map['id'],
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      riskLevel: map['risk_level'] ?? 'unknown',
      healthImpacts: _parseStringList(map['health_impacts']),
      commonProducts: _parseStringList(map['common_products']),
      alternatives: _parseStringList(map['alternatives']),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'risk_level': riskLevel,
      'health_impacts': healthImpacts.join(', '),
      'common_products': commonProducts.join(', '),
      'alternatives': alternatives.join(', '),
    };
  }
  
  factory AdditiveModel.fromJson(Map<String, dynamic> json) {
    return AdditiveModel(
      id: json['id'],
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      riskLevel: json['risk_level'] ?? 'unknown',
      healthImpacts: List<String>.from(json['health_impacts'] ?? []),
      commonProducts: List<String>.from(json['common_products'] ?? []),
      alternatives: List<String>.from(json['alternatives'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'risk_level': riskLevel,
      'health_impacts': healthImpacts,
      'common_products': commonProducts,
      'alternatives': alternatives,
    };
  }
  
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      return value.split(', ').where((e) => e.isNotEmpty).toList();
    }
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}