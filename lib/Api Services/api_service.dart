import 'dart:typed_data' show Uint8List;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_generative_ai/google_generative_ai.dart';

import '../Model/analysis_model.dart';
import 'api_service_interface.dart';

class ApiService implements ApiServiceInterface {
  final Dio _dio = Dio();

  // Base URLs
  final String baseUrl = 'https://api.example.com/v1';

  static const String _aiApiKey =
      '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';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  static Future<FoodProductAnalysis> analyzeImage(Uint8List imageBytes) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: _aiApiKey,
      );

      final prompt = await _getPrompt();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([TextPart(prompt), imagePart])
      ]);

      if (response.text == null) {
        throw Exception('Failed to get a response from the API.');
      }

      return foodProductAnalysisFromJson(response.text!);
    } catch (e) {
      print('Error in analyzeImage: $e');
      rethrow;
    }
  }

  static Future<String> _getPrompt() async {
    final knowledgeBase = await rootBundle.loadString(
      'assets/files/knowledge.json',
    );
    return '''You are a highly specialized AI assistant with expertise in food science and safety. Your task is to analyze the ingredient list from the provided image and identify any potentially harmful substances based on a comprehensive internal knowledge base.

### KNOWLEDGE BASE
$knowledgeBase

### OUTPUT FORMAT
Respond only with a valid JSON object without any additional text.''';
  }

  @override
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response<T>> multipartPost<T>(
    String endpoint, {
    required List<MultipartFile> files,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    try {
      final formData = FormData();

      for (var file in files) {
        formData.files.add(MapEntry('file', file));
      }

      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      return await _dio.post<T>(
        endpoint,
        data: formData,
        options: options ?? Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Network timeout');
      case DioExceptionType.badResponse:
        return Exception(
          'Server error: ${error.response?.statusCode} - ${error.response?.statusMessage}',
        );
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${error.message}');
    }
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }
}
