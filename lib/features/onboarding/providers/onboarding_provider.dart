import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/database_service.dart';

class OnboardingProvider extends ChangeNotifier {
  // User preferences
  List<String> _selectedAllergies = [];
  List<String> _dietaryRestrictions = [];
  String? _healthGoal;
  bool _enableNotifications = true;
  bool _enableHealthTracking = true;
  
  // Available options
  final List<String> availableAllergies = [
    'Gluten',
    'Dairy',
    'Eggs',
    'Peanuts',
    'Tree Nuts',
    'Soy',
    'Fish',
    'Shellfish',
    'Sesame',
  ];
  
  final List<String> availableDietaryRestrictions = [
    'Vegetarian',
    'Vegan',
    'Halal',
    'Kosher',
    'Low Sodium',
    'Sugar Free',
    'Keto',
    'Paleo',
  ];
  
  final List<String> availableHealthGoals = [
    'Reduce processed foods',
    'Avoid artificial colors',
    'Minimize preservatives',
    'Clean eating',
    'Weight management',
    'Better nutrition',
  ];
  
  // Getters
  List<String> get selectedAllergies => _selectedAllergies;
  List<String> get dietaryRestrictions => _dietaryRestrictions;
  String? get healthGoal => _healthGoal;
  bool get enableNotifications => _enableNotifications;
  bool get enableHealthTracking => _enableHealthTracking;
  
  // Allergy management
  void toggleAllergy(String allergy) {
    if (_selectedAllergies.contains(allergy)) {
      _selectedAllergies.remove(allergy);
    } else {
      _selectedAllergies.add(allergy);
    }
    notifyListeners();
  }
  
  bool isAllergySelected(String allergy) {
    return _selectedAllergies.contains(allergy);
  }
  
  // Dietary restrictions management
  void toggleDietaryRestriction(String restriction) {
    if (_dietaryRestrictions.contains(restriction)) {
      _dietaryRestrictions.remove(restriction);
    } else {
      _dietaryRestrictions.add(restriction);
    }
    notifyListeners();
  }
  
  bool isDietaryRestrictionSelected(String restriction) {
    return _dietaryRestrictions.contains(restriction);
  }
  
  // Health goal
  void setHealthGoal(String? goal) {
    _healthGoal = goal;
    notifyListeners();
  }
  
  // Notification settings
  void setEnableNotifications(bool value) {
    _enableNotifications = value;
    notifyListeners();
  }
  
  // Health tracking settings
  void setEnableHealthTracking(bool value) {
    _enableHealthTracking = value;
    notifyListeners();
  }
  
  // Save preferences
  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final db = DatabaseService.instance;
    
    // Save to SharedPreferences
    await prefs.setStringList('allergies', _selectedAllergies);
    await prefs.setStringList('dietaryRestrictions', _dietaryRestrictions);
    if (_healthGoal != null) {
      await prefs.setString('healthGoal', _healthGoal!);
    }
    await prefs.setBool('enableNotifications', _enableNotifications);
    await prefs.setBool('enableHealthTracking', _enableHealthTracking);
    
    // Save to database
    await db.setPreference('allergies', _selectedAllergies.join(','));
    await db.setPreference('dietaryRestrictions', _dietaryRestrictions.join(','));
    if (_healthGoal != null) {
      await db.setPreference('healthGoal', _healthGoal!);
    }
    await db.setPreference('enableNotifications', _enableNotifications.toString());
    await db.setPreference('enableHealthTracking', _enableHealthTracking.toString());
    
    // Add high-risk additives to avoid list based on allergies
    await _setupInitialAvoidList();
  }
  
  Future<void> _setupInitialAvoidList() async {
    final db = DatabaseService.instance;
    
    // Map allergies to common additives to avoid
    final allergyAdditiveMap = {
      'Gluten': ['E1100', 'E1101', 'E1102'], // Amylases
      'Dairy': ['E270', 'E325', 'E326', 'E327'], // Lactic acid and lactates
      'Eggs': ['E322'], // Lecithin (can be from eggs)
      'Soy': ['E322', 'E426'], // Lecithin, soy hemicellulose
    };
    
    for (final allergy in _selectedAllergies) {
      final additives = allergyAdditiveMap[allergy] ?? [];
      for (final additive in additives) {
        await db.addToAvoidList(additive, 'Allergy: $allergy');
      }
    }
    
    // Add common harmful additives for health-conscious users
    if (_healthGoal == 'Avoid artificial colors' || 
        _healthGoal == 'Clean eating') {
      final artificialColors = ['E102', 'E110', 'E122', 'E123', 'E124', 'E129'];
      for (final color in artificialColors) {
        await db.addToAvoidList(color, 'Health goal: $_healthGoal');
      }
    }
  }
  
  // Load preferences (for editing later)
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    _selectedAllergies = prefs.getStringList('allergies') ?? [];
    _dietaryRestrictions = prefs.getStringList('dietaryRestrictions') ?? [];
    _healthGoal = prefs.getString('healthGoal');
    _enableNotifications = prefs.getBool('enableNotifications') ?? true;
    _enableHealthTracking = prefs.getBool('enableHealthTracking') ?? true;
    
    notifyListeners();
  }
}