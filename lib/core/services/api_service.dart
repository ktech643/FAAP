import 'package:dio/dio.dart';
import '../../features/scanning/models/product_model.dart';
import '../../features/search/models/additive_model.dart';

class ApiService {
  late final Dio _dio;
  static const String baseUrl = 'https://api.faapscan.com/v1'; // Replace with actual API
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, handler) {
        // Handle errors globally
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }
  
  // Product endpoints
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      // For demo purposes, return mock data
      await Future.delayed(const Duration(seconds: 2));
      
      return ProductModel(
        id: '1',
        barcode: barcode,
        name: 'Sample Product',
        brand: 'Sample Brand',
        category: 'Snacks',
        imageUrl: 'https://via.placeholder.com/300',
        ingredients: ['Wheat flour', 'Sugar', 'Salt', 'E102', 'E211'],
        additives: ['E102', 'E211'],
        riskLevel: 'medium',
        nutritionalInfo: {
          'calories': '250',
          'protein': '5g',
          'carbs': '40g',
          'fat': '8g',
          'sugar': '15g',
          'sodium': '200mg',
        },
      );
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
  
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        ProductModel(
          id: '1',
          barcode: '1234567890',
          name: 'Product 1',
          brand: 'Brand A',
          category: 'Snacks',
          imageUrl: 'https://via.placeholder.com/300',
          ingredients: ['Ingredient 1', 'Ingredient 2'],
          additives: ['E102'],
          riskLevel: 'high',
          nutritionalInfo: {},
        ),
        ProductModel(
          id: '2',
          barcode: '0987654321',
          name: 'Product 2',
          brand: 'Brand B',
          category: 'Beverages',
          imageUrl: 'https://via.placeholder.com/300',
          ingredients: ['Ingredient 3', 'Ingredient 4'],
          additives: ['E300'],
          riskLevel: 'low',
          nutritionalInfo: {},
        ),
      ];
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }
  
  // Additive endpoints
  Future<List<AdditiveModel>> getAdditives({String? category}) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      
      return [
        AdditiveModel(
          id: 1,
          code: 'E102',
          name: 'Tartrazine',
          description: 'Yellow synthetic food dye',
          riskLevel: 'high',
          healthImpacts: ['May cause hyperactivity', 'Allergic reactions'],
          commonProducts: ['Soft drinks', 'Candy'],
          alternatives: ['Turmeric', 'Saffron'],
        ),
        AdditiveModel(
          id: 2,
          code: 'E211',
          name: 'Sodium Benzoate',
          description: 'Preservative',
          riskLevel: 'medium',
          healthImpacts: ['May form benzene with vitamin C'],
          commonProducts: ['Soft drinks', 'Pickles'],
          alternatives: ['Natural preservatives'],
        ),
      ];
    } catch (e) {
      print('Error fetching additives: $e');
      return [];
    }
  }
  
  // Analytics endpoints
  Future<void> logScan(String barcode, String? productName) async {
    try {
      // Mock implementation
      print('Logging scan: $barcode - $productName');
    } catch (e) {
      print('Error logging scan: $e');
    }
  }
  
  Future<void> logAdditiveView(String additiveCode) async {
    try {
      // Mock implementation
      print('Logging additive view: $additiveCode');
    } catch (e) {
      print('Error logging additive view: $e');
    }
  }
  
  // User endpoints
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      
      return {
        'totalScans': 145,
        'weeklyScans': 23,
        'avoidedAdditives': 12,
        'healthScore': 78,
        'mostScannedCategory': 'Snacks',
        'recentTrend': 'improving',
      };
    } catch (e) {
      print('Error fetching user stats: $e');
      return {};
    }
  }
  
  // Premium endpoints
  Future<List<Map<String, dynamic>>> getAlternativeProducts(String productId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        {
          'id': 'alt1',
          'name': 'Healthier Alternative 1',
          'brand': 'Organic Brand',
          'riskLevel': 'low',
          'matchScore': 85,
        },
        {
          'id': 'alt2',
          'name': 'Healthier Alternative 2',
          'brand': 'Natural Brand',
          'riskLevel': 'low',
          'matchScore': 78,
        },
      ];
    } catch (e) {
      print('Error fetching alternatives: $e');
      return [];
    }
  }
}