import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static final SecureStorageHelper _instance = SecureStorageHelper._internal();
  factory SecureStorageHelper() => _instance;
  SecureStorageHelper._internal();

  final _storage = const FlutterSecureStorage();

  static const _geminiKey = 'gemini_api_key';

  Future<void> saveGeminiKey(String key) async {
    await _storage.write(key: _geminiKey, value: key);
  }

  Future<String?> getGeminiKey() async {
    return await _storage.read(key: _geminiKey);
  }

  Future<void> deleteGeminiKey() async {
    await _storage.delete(key: _geminiKey);
  }
}
