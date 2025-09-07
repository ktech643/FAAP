import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/database_service.dart';
import '../../scanning/models/product_model.dart';
import '../models/additive_model.dart';

enum SearchType {
  all,
  products,
  additives,
  brands,
}

class SearchProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  // Search state
  String _searchQuery = '';
  SearchType _searchType = SearchType.all;
  bool _isSearching = false;
  
  // Results
  List<ProductModel> _productResults = [];
  List<AdditiveModel> _additiveResults = [];
  List<String> _brandResults = [];
  
  // Recent searches
  List<String> _recentSearches = [];
  
  // Getters
  String get searchQuery => _searchQuery;
  SearchType get searchType => _searchType;
  bool get isSearching => _isSearching;
  List<ProductModel> get productResults => _productResults;
  List<AdditiveModel> get additiveResults => _additiveResults;
  List<String> get brandResults => _brandResults;
  List<String> get recentSearches => _recentSearches;
  
  bool get hasResults => 
      _productResults.isNotEmpty || 
      _additiveResults.isNotEmpty || 
      _brandResults.isNotEmpty;
  
  SearchProvider(this._apiService) {
    _loadRecentSearches();
  }
  
  Future<void> _loadRecentSearches() async {
    // In a real app, load from SharedPreferences
    _recentSearches = [
      'E102',
      'Coca Cola',
      'Sodium Benzoate',
      'Chips',
      'E211',
    ];
    notifyListeners();
  }
  
  void setSearchType(SearchType type) {
    _searchType = type;
    notifyListeners();
    
    // Re-run search with new type if query exists
    if (_searchQuery.isNotEmpty) {
      search(_searchQuery);
    }
  }
  
  Future<void> search(String query) async {
    if (query.isEmpty) {
      clearResults();
      return;
    }
    
    _searchQuery = query;
    _isSearching = true;
    notifyListeners();
    
    try {
      switch (_searchType) {
        case SearchType.all:
          await _searchAll(query);
          break;
        case SearchType.products:
          await _searchProducts(query);
          break;
        case SearchType.additives:
          await _searchAdditives(query);
          break;
        case SearchType.brands:
          await _searchBrands(query);
          break;
      }
      
      // Add to recent searches
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
        // Save to SharedPreferences in real app
      }
    } catch (e) {
      print('Search error: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
  
  Future<void> _searchAll(String query) async {
    // Search in all categories
    await Future.wait([
      _searchProducts(query),
      _searchAdditives(query),
      _searchBrands(query),
    ]);
  }
  
  Future<void> _searchProducts(String query) async {
    _productResults = await _apiService.searchProducts(query);
  }
  
  Future<void> _searchAdditives(String query) async {
    final db = DatabaseService.instance;
    _additiveResults = await db.searchAdditives(query);
  }
  
  Future<void> _searchBrands(String query) async {
    // Mock implementation
    _brandResults = [
      'Brand A',
      'Brand B',
      'Brand C',
    ].where((brand) => brand.toLowerCase().contains(query.toLowerCase())).toList();
  }
  
  void clearResults() {
    _searchQuery = '';
    _productResults = [];
    _additiveResults = [];
    _brandResults = [];
    notifyListeners();
  }
  
  void removeRecentSearch(String search) {
    _recentSearches.remove(search);
    notifyListeners();
    // Save to SharedPreferences in real app
  }
  
  void clearRecentSearches() {
    _recentSearches.clear();
    notifyListeners();
    // Save to SharedPreferences in real app
  }
}