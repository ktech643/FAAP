import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService._init();
  late final FirebaseAnalytics _analytics;
  
  AnalyticsService._init();
  
  Future<void> initialize() async {
    // Initialize Firebase Analytics
    // Note: Firebase needs to be configured with google-services.json/GoogleService-Info.plist
    try {
      _analytics = FirebaseAnalytics.instance;
      await _analytics.setAnalyticsCollectionEnabled(true);
    } catch (e) {
      print('Analytics initialization error: $e');
    }
  }
  
  // Screen tracking
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenName,
      );
    } catch (e) {
      print('Error logging screen view: $e');
    }
  }
  
  // User actions
  Future<void> logScanEvent({
    required String barcode,
    String? productName,
    String? riskLevel,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'product_scan',
        parameters: {
          'barcode': barcode,
          if (productName != null) 'product_name': productName,
          if (riskLevel != null) 'risk_level': riskLevel,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Error logging scan event: $e');
    }
  }
  
  Future<void> logSearchEvent({
    required String query,
    required String searchType,
    int? resultsCount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'search',
        parameters: {
          'query': query,
          'search_type': searchType, // 'product', 'additive', 'brand'
          if (resultsCount != null) 'results_count': resultsCount,
        },
      );
    } catch (e) {
      print('Error logging search event: $e');
    }
  }
  
  Future<void> logAdditiveView({
    required String additiveCode,
    required String additiveName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'additive_view',
        parameters: {
          'additive_code': additiveCode,
          'additive_name': additiveName,
        },
      );
    } catch (e) {
      print('Error logging additive view: $e');
    }
  }
  
  Future<void> logAvoidListAction({
    required String action, // 'add' or 'remove'
    required String additiveCode,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'avoid_list_action',
        parameters: {
          'action': action,
          'additive_code': additiveCode,
        },
      );
    } catch (e) {
      print('Error logging avoid list action: $e');
    }
  }
  
  // User properties
  Future<void> setUserProperties({
    String? dietaryPreference,
    List<String>? allergies,
    bool? isPremium,
  }) async {
    try {
      if (dietaryPreference != null) {
        await _analytics.setUserProperty(
          name: 'dietary_preference',
          value: dietaryPreference,
        );
      }
      
      if (allergies != null) {
        await _analytics.setUserProperty(
          name: 'allergies',
          value: allergies.join(','),
        );
      }
      
      if (isPremium != null) {
        await _analytics.setUserProperty(
          name: 'is_premium',
          value: isPremium.toString(),
        );
      }
    } catch (e) {
      print('Error setting user properties: $e');
    }
  }
  
  // Conversion events
  Future<void> logPremiumConversion({
    required String source,
    required double price,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'premium_conversion',
        parameters: {
          'source': source, // 'scan_limit', 'feature_prompt', etc.
          'price': price,
          'currency': 'USD',
        },
      );
    } catch (e) {
      print('Error logging premium conversion: $e');
    }
  }
  
  Future<void> logOnboardingComplete({
    required int stepsCompleted,
    required int totalSteps,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'onboarding_complete',
        parameters: {
          'steps_completed': stepsCompleted,
          'total_steps': totalSteps,
          'completion_rate': (stepsCompleted / totalSteps * 100).round(),
        },
      );
    } catch (e) {
      print('Error logging onboarding complete: $e');
    }
  }
  
  // Engagement metrics
  Future<void> logShareAction({
    required String contentType,
    required String shareMethod,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'share',
        parameters: {
          'content_type': contentType, // 'product', 'health_report', etc.
          'method': shareMethod, // 'social_media', 'messaging', etc.
        },
      );
    } catch (e) {
      print('Error logging share action: $e');
    }
  }
  
  Future<void> logEngagement({
    required String feature,
    required String action,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'feature_engagement',
        parameters: {
          'feature': feature,
          'action': action,
          if (additionalParams != null) ...additionalParams,
        },
      );
    } catch (e) {
      print('Error logging engagement: $e');
    }
  }
}