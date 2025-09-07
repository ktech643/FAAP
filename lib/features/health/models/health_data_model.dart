class HealthDataModel {
  final int healthScore;
  final String trend;
  final Map<String, int> weeklyScans;
  final Map<String, int> additiveConsumption;
  final List<HealthInsight> insights;
  final DateTime lastUpdated;
  
  HealthDataModel({
    required this.healthScore,
    required this.trend,
    required this.weeklyScans,
    required this.additiveConsumption,
    required this.insights,
    required this.lastUpdated,
  });
  
  factory HealthDataModel.empty() {
    return HealthDataModel(
      healthScore: 100,
      trend: 'stable',
      weeklyScans: {},
      additiveConsumption: {},
      insights: [],
      lastUpdated: DateTime.now(),
    );
  }
}

class HealthInsight {
  final String id;
  final String title;
  final String description;
  final InsightType type;
  final String? actionText;
  final String? actionRoute;
  
  HealthInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.actionText,
    this.actionRoute,
  });
}

enum InsightType {
  positive,
  warning,
  tip,
  achievement,
}