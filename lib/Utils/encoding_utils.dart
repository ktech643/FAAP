import 'dart:convert';

/// Utility class for encoding and decoding sensitive data like API keys
class EncodingUtils {
  /// Decode a base64 encoded string
  static String decodeFromBase64(String encoded) {
    try {
      return utf8.decode(base64Decode(encoded));
    } catch (e) {
      throw Exception('Failed to decode API key: $e');
    }
  }

  /// Encode a string to base64
  static String encodeToBase64(String plain) {
    try {
      return base64Encode(utf8.encode(plain));
    } catch (e) {
      throw Exception('Failed to encode API key: $e');
    }
  }
}
