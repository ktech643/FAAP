import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyNotificationPermissionAsked = 'notification_permission_asked';

  /// Check if user has completed onboarding
  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Mark onboarding as completed
  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }

  /// Check if notification permission has been asked
  static Future<bool> hasAskedNotificationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationPermissionAsked) ?? false;
  }

  /// Mark notification permission as asked
  static Future<void> setNotificationPermissionAsked(bool asked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationPermissionAsked, asked);
  }

  /// Clear all preferences (for logout/reset)
  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}







