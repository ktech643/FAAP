import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

// Copy constants from supabase_config.dart
const String supabaseUrl = 'https://ndvhoqjuzabfhdqdvrjf.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5kdmhvcWp1emFiZmhkcWR2cmpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyMjE4ODIsImV4cCI6MjA3Njc5Nzg4Mn0.5XtNfz_oiwzuAHiwN9DXH9V2PRO0Wi4lqbpynmIcSZE';

void main() {
  final dio = Dio();
  String? accessToken;
  String? userId;
  String? testProductId;
  
  final testEmail = 'api_test_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final testPassword = 'TestPassword123!';

  setUpAll(() async {
    // 1. Sign up a test user to get a valid token
    try {
      final response = await dio.post(
        '$supabaseUrl/auth/v1/signup',
        options: Options(headers: {'apikey': supabaseAnonKey}),
        data: {
          'email': testEmail,
          'password': testPassword,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        accessToken = response.data['access_token'];
        userId = response.data['user']['id'];
        print('Test user signed up. ID: $userId');
      }
    } on DioException catch (e) {
      print('Signup failed: ${e.response?.data}');
      // If user already exists (shouldn't happen with timestamp email), try login
      throw Exception('Failed to setup test user: $e');
    }
  });

  tearDownAll(() async {
    // Clean up created product if any
    if (testProductId != null && accessToken != null) {
      try {
        await dio.delete(
          '$supabaseUrl/rest/v1/products?id=eq.$testProductId',
          options: Options(
            headers: {
              'apikey': supabaseAnonKey,
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );
        print('Cleaned up test product.');
      } catch (e) {
        print('Cleanup product failed: $e');
      }
    }
    
    // Note: Deleting users via Supabase API usually requires service_role key, 
    // so we skip deleting the test user to avoid leaking a powerful key. 
    // It's acceptable for this test.
  });

  group('Analyze Photo API Tests', () {
    test('Without token - should fail (Unauthorized)', () async {
      try {
        await dio.post(
          '$supabaseUrl/functions/v1/analyze_product',
          options: Options(
            headers: {
              // Intentionally omitting Authorization
              'Content-Type': 'application/json',
            },
          ),
          data: {
            'prompt': 'dummy prompt',
            'imageUrl': 'https://example.com/dummy.jpg',
          },
        );
        fail('Expected exception but request succeeded');
      } on DioException catch (e) {
        expect(e.response?.statusCode, isNotNull);
        // Supabase Edge Functions without valid Auth header return 401 or 403
        expect(e.response?.statusCode == 401 || e.response?.statusCode == 403, isTrue, 
          reason: 'Expected 401 or 403, got ${e.response?.statusCode}');
      }
    });

    test('With token - should authenticate successfully', () async {
      assert(accessToken != null, 'Setup failed to provide token');
      try {
        final response = await dio.post(
          '$supabaseUrl/functions/v1/analyze_product',
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ),
          data: {
            'prompt': 'dummy prompt',
            'imageUrl': 'https://example.com/dummy.jpg',
          },
        );
        
        // If it returns 200, it means auth and function execution succeeded
        expect(response.statusCode, 200);
      } on DioException catch (e) {
        // If the Edge function fails internally because of a dummy prompt/image,
        // it should NOT be 401 or 403. It might be 500 or 400.
        // The key is that authentication passed.
        expect(e.response?.statusCode, isNot(401));
        expect(e.response?.statusCode, isNot(403));
        print('Edge function returned ${e.response?.statusCode} with data: ${e.response?.data}');
      }
    });
  });

  group('Get Products API Tests', () {
    test('Without token (using Anon Key) - should return empty list (RLS)', () async {
      final response = await dio.get(
        '$supabaseUrl/rest/v1/products?select=*',
        options: Options(
          headers: {
            'apikey': supabaseAnonKey,
            'Authorization': 'Bearer $supabaseAnonKey',
          },
        ),
      );
      
      // Usually RLS returns 200 OK but an empty array if not authorized to see any rows
      expect(response.statusCode, 200);
      expect(response.data, isA<List>());
      expect((response.data as List).isEmpty, isTrue);
    });

    test('With token - should return a list', () async {
      assert(accessToken != null);
      final response = await dio.get(
        '$supabaseUrl/rest/v1/products?select=*',
        options: Options(
          headers: {
            'apikey': supabaseAnonKey,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      expect(response.statusCode, 200);
      expect(response.data, isA<List>());
    });
  });

  group('Add Product API Tests', () {
    final dummyProductData = {
      'title': 'Test Product',
      'description': 'Test Description',
      'status': 'Safe',
      'risk_level': 'Low',
      'is_favorite': false,
    };

    test('Without token (Anon Key) - should fail to insert (RLS)', () async {
      try {
        await dio.post(
          '$supabaseUrl/rest/v1/products',
          options: Options(
            headers: {
              'apikey': supabaseAnonKey,
              'Authorization': 'Bearer $supabaseAnonKey',
              'Prefer': 'return=representation',
              'Content-Type': 'application/json',
            },
          ),
          data: dummyProductData, // Note: no owner provided, even if provided it shouldn't work
        );
        fail('Expected insert to fail due to RLS');
      } on DioException catch (e) {
        expect(e.response?.statusCode, isNotNull);
        // Supabase returns 401 or 403 or 400 for RLS violation
        final isAuthError = e.response!.statusCode == 401 || e.response!.statusCode == 403 || e.response!.statusCode == 400;
        expect(isAuthError, isTrue, reason: 'Status code was ${e.response?.statusCode}');
      }
    });

    test('With token - should insert successfully', () async {
      assert(accessToken != null);
      assert(userId != null);

      final insertData = Map<String, dynamic>.from(dummyProductData);
      insertData['owner'] = userId; // Ensure owner matches authenticated user

      final response = await dio.post(
        '$supabaseUrl/rest/v1/products',
        options: Options(
          headers: {
            'apikey': supabaseAnonKey,
            'Authorization': 'Bearer $accessToken',
            'Prefer': 'return=representation',
            'Content-Type': 'application/json',
          },
        ),
        data: insertData,
      );
      
      expect(response.statusCode, 201); // 201 Created
      expect(response.data, isA<List>());
      expect((response.data as List).isNotEmpty, isTrue);
      
      // Save ID for cleanup
      testProductId = response.data[0]['id'];
    });
  });
}
