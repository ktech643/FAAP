import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/database_service.dart';
import '../models/user_preferences_model.dart';

class ProfileProvider extends ChangeNotifier {
  UserPreferencesModel _preferences = UserPreferencesModel.empty();
  String? _userName;
  String? _userEmail;
  int _totalScans = 0;
  int _avoidedAdditives = 0;
  
  // Getters
  UserPreferencesModel get preferences => _preferences;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  int get totalScans => _totalScans;
  int get avoidedAdditives => _avoidedAdditives;
  bool get isPremium => _preferences.isPremium;
  
  ProfileProvider() {
    loadProfile();
  }
  
  Future<void> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final db = DatabaseService.instance;
      
      // Load user info
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('userEmail');
      
      // Load preferences
      final allergies = prefs.getStringList('allergies') ?? [];
      final dietaryRestrictions = prefs.getStringList('dietaryRestrictions') ?? [];
      final healthGoal = prefs.getString('healthGoal');
      final enableNotifications = prefs.getBool('enableNotifications') ?? true;
      final enableHealthTracking = prefs.getBool('enableHealthTracking') ?? true;
      final isPremium = prefs.getBool('isPremium') ?? false;
      final premiumExpiryTimestamp = prefs.getInt('premiumExpiryDate');
      
      _preferences = UserPreferencesModel(
        allergies: allergies,
        dietaryRestrictions: dietaryRestrictions,
        healthGoal: healthGoal,
        enableNotifications: enableNotifications,
        enableHealthTracking: enableHealthTracking,
        isPremium: isPremium,
        premiumExpiryDate: premiumExpiryTimestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(premiumExpiryTimestamp)
            : null,
      );
      
      // Load statistics
      final scanHistory = await db.getScanHistory();
      _totalScans = scanHistory.length;
      
      final avoidList = await db.getAvoidList();
      _avoidedAdditives = avoidList.length;
      
      notifyListeners();
    } catch (e) {
      print('Error loading profile: $e');
    }
  }
  
  Future<void> updateUserName(String name) async {
    _userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    notifyListeners();
  }
  
  Future<void> updateUserEmail(String email) async {
    _userEmail = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    notifyListeners();
  }
  
  Future<void> updatePreferences(UserPreferencesModel newPreferences) async {
    _preferences = newPreferences;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('allergies', newPreferences.allergies);
    await prefs.setStringList('dietaryRestrictions', newPreferences.dietaryRestrictions);
    if (newPreferences.healthGoal != null) {
      await prefs.setString('healthGoal', newPreferences.healthGoal!);
    }
    await prefs.setBool('enableNotifications', newPreferences.enableNotifications);
    await prefs.setBool('enableHealthTracking', newPreferences.enableHealthTracking);
    
    notifyListeners();
  }
  
  Future<void> upgradeToPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', true);
    
    // Set expiry date to 1 year from now
    final expiryDate = DateTime.now().add(const Duration(days: 365));
    await prefs.setInt('premiumExpiryDate', expiryDate.millisecondsSinceEpoch);
    
    _preferences = _preferences.copyWith(
      isPremium: true,
      premiumExpiryDate: expiryDate,
    );
    
    notifyListeners();
  }
  
  Future<void> signOut() async {
    // Clear all user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    // Reset to defaults
    _preferences = UserPreferencesModel.empty();
    _userName = null;
    _userEmail = null;
    _totalScans = 0;
    _avoidedAdditives = 0;
    
    notifyListeners();
  }
  
  void incrementScanCount() {
    _totalScans++;
    notifyListeners();
  }
  
  void updateAvoidedAdditivesCount(int count) {
    _avoidedAdditives = count;
    notifyListeners();
  }
}