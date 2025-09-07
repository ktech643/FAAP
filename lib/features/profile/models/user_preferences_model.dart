class UserPreferencesModel {
  final List<String> allergies;
  final List<String> dietaryRestrictions;
  final String? healthGoal;
  final bool enableNotifications;
  final bool enableHealthTracking;
  final bool isPremium;
  final DateTime? premiumExpiryDate;
  
  UserPreferencesModel({
    required this.allergies,
    required this.dietaryRestrictions,
    this.healthGoal,
    required this.enableNotifications,
    required this.enableHealthTracking,
    this.isPremium = false,
    this.premiumExpiryDate,
  });
  
  factory UserPreferencesModel.empty() {
    return UserPreferencesModel(
      allergies: [],
      dietaryRestrictions: [],
      healthGoal: null,
      enableNotifications: true,
      enableHealthTracking: true,
      isPremium: false,
      premiumExpiryDate: null,
    );
  }
  
  UserPreferencesModel copyWith({
    List<String>? allergies,
    List<String>? dietaryRestrictions,
    String? healthGoal,
    bool? enableNotifications,
    bool? enableHealthTracking,
    bool? isPremium,
    DateTime? premiumExpiryDate,
  }) {
    return UserPreferencesModel(
      allergies: allergies ?? this.allergies,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      healthGoal: healthGoal ?? this.healthGoal,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableHealthTracking: enableHealthTracking ?? this.enableHealthTracking,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'allergies': allergies.join(','),
      'dietary_restrictions': dietaryRestrictions.join(','),
      'health_goal': healthGoal,
      'enable_notifications': enableNotifications,
      'enable_health_tracking': enableHealthTracking,
      'is_premium': isPremium,
      'premium_expiry_date': premiumExpiryDate?.millisecondsSinceEpoch,
    };
  }
  
  factory UserPreferencesModel.fromMap(Map<String, dynamic> map) {
    return UserPreferencesModel(
      allergies: (map['allergies'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      dietaryRestrictions: (map['dietary_restrictions'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      healthGoal: map['health_goal'],
      enableNotifications: map['enable_notifications'] ?? true,
      enableHealthTracking: map['enable_health_tracking'] ?? true,
      isPremium: map['is_premium'] ?? false,
      premiumExpiryDate: map['premium_expiry_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['premium_expiry_date'])
          : null,
    );
  }
}