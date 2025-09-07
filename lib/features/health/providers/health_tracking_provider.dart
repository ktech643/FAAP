import 'package:flutter/material.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/api_service.dart';
import '../../scanning/models/scan_history_model.dart';
import '../models/health_data_model.dart';

class HealthTrackingProvider extends ChangeNotifier {
  // Health data
  int _healthScore = 0;
  Map<String, int> _weeklyScans = {};
  Map<String, int> _additiveConsumption = {};
  List<String> _topHarmfulAdditives = [];
  String _trend = 'stable';
  
  // Statistics
  int _totalScansThisWeek = 0;
  int _highRiskProductsThisWeek = 0;
  int _improvementPercentage = 0;
  
  // Loading state
  bool _isLoading = true;
  
  // Getters
  int get healthScore => _healthScore;
  Map<String, int> get weeklyScans => _weeklyScans;
  Map<String, int> get additiveConsumption => _additiveConsumption;
  List<String> get topHarmfulAdditives => _topHarmfulAdditives;
  String get trend => _trend;
  int get totalScansThisWeek => _totalScansThisWeek;
  int get highRiskProductsThisWeek => _highRiskProductsThisWeek;
  int get improvementPercentage => _improvementPercentage;
  bool get isLoading => _isLoading;
  
  HealthTrackingProvider() {
    loadHealthData();
  }
  
  Future<void> loadHealthData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Load scan history
      final db = DatabaseService.instance;
      final scanHistory = await db.getScanHistory();
      
      // Calculate health score and statistics
      await _calculateHealthMetrics(scanHistory);
      
      // Load user stats from API
      final apiService = ApiService();
      final stats = await apiService.getUserStats('user123');
      
      _healthScore = stats['healthScore'] ?? 0;
      _trend = stats['recentTrend'] ?? 'stable';
      
    } catch (e) {
      print('Error loading health data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> _calculateHealthMetrics(List<ScanHistoryModel> scanHistory) async {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    
    // Filter scans from this week
    final thisWeekScans = scanHistory.where((scan) {
      return scan.scanDate.isAfter(oneWeekAgo);
    }).toList();
    
    _totalScansThisWeek = thisWeekScans.length;
    
    // Count high risk products
    _highRiskProductsThisWeek = thisWeekScans.where((scan) {
      return scan.riskLevel == 'high';
    }).length;
    
    // Calculate weekly scan distribution
    _weeklyScans = {};
    for (var i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayName = _getDayName(day.weekday);
      final dayScans = thisWeekScans.where((scan) {
        return scan.scanDate.day == day.day &&
               scan.scanDate.month == day.month &&
               scan.scanDate.year == day.year;
      }).length;
      _weeklyScans[dayName] = dayScans;
    }
    
    // Calculate additive consumption
    final additiveCount = <String, int>{};
    for (final scan in thisWeekScans) {
      for (final additive in scan.harmfulAdditives) {
        additiveCount[additive] = (additiveCount[additive] ?? 0) + 1;
      }
    }
    
    // Sort additives by count
    final sortedAdditives = additiveCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Get top 5 harmful additives
    _topHarmfulAdditives = sortedAdditives
        .take(5)
        .map((e) => e.key)
        .toList();
    
    // Create additive consumption map for chart
    _additiveConsumption = Map.fromEntries(
      sortedAdditives.take(5),
    );
    
    // Calculate improvement percentage (mock)
    _improvementPercentage = 23;
  }
  
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
  
  // Calculate health score based on recent scanning patterns
  int calculateHealthScore(List<ScanHistoryModel> recentScans) {
    if (recentScans.isEmpty) return 100;
    
    int score = 100;
    int highRiskCount = 0;
    int mediumRiskCount = 0;
    
    for (final scan in recentScans) {
      if (scan.riskLevel == 'high') {
        highRiskCount++;
        score -= 10;
      } else if (scan.riskLevel == 'medium') {
        mediumRiskCount++;
        score -= 5;
      }
    }
    
    // Ensure score doesn't go below 0
    return score.clamp(0, 100);
  }
  
  // Get health recommendations based on data
  List<String> getHealthRecommendations() {
    final recommendations = <String>[];
    
    if (_highRiskProductsThisWeek > 3) {
      recommendations.add('Try to reduce high-risk product consumption');
    }
    
    if (_topHarmfulAdditives.contains('E102')) {
      recommendations.add('Avoid products with Tartrazine (E102)');
    }
    
    if (_totalScansThisWeek < 5) {
      recommendations.add('Scan more products to track your health better');
    }
    
    if (_healthScore < 60) {
      recommendations.add('Your health score needs improvement');
    }
    
    return recommendations;
  }
  
  // Refresh data
  Future<void> refresh() async {
    await loadHealthData();
  }
}