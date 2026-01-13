// lib/Api Services/api_service_interface.dart

import 'package:dio/dio.dart';

abstract class ApiServiceInterface {
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> multipartPost<T>(
    String endpoint, {
    required List<MultipartFile> files,
    Map<String, dynamic>? data,
    Options? options,
  });
}
