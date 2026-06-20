import 'dart:convert';
import 'package:http/http.dart' as http;

/// Utility service for safe HTTP operations with UTF-8 encoding
class ApiService {
  static final _defaultClient = http.Client();

  /// Safely fetch JSON with proper UTF-8 decoding
  static Future<Map<String, dynamic>> getJson(String url) async {
    try {
      final response = await _defaultClient.get(
        Uri.parse(url),
        headers: {
          'Accept-Charset': 'utf-8',
          'Accept': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        // Explicitly decode as UTF-8 to handle Arabic and special chars
        final decoded = utf8.decode(response.bodyBytes);
        return jsonDecode(decoded);
      }
      throw Exception('Failed with status: ${response.statusCode}');
    } on Exception catch (e) {
      print('ApiService.getJson Error: $e');
      rethrow;
    }
  }

  /// Safely post JSON with proper UTF-8 encoding/decoding
  static Future<Map<String, dynamic>> postJson(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _defaultClient.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Explicitly decode as UTF-8
        final decoded = utf8.decode(response.bodyBytes);
        return jsonDecode(decoded);
      }
      throw Exception('Failed with status: ${response.statusCode}');
    } on Exception catch (e) {
      print('ApiService.postJson Error: $e');
      rethrow;
    }
  }

  /// Safely post with form data (for Cloudinary uploads)
  static Future<String> postMultipartJson(
    String url,
    http.MultipartRequest request,
  ) async {
    try {
      // Add UTF-8 headers
      request.headers['Accept-Charset'] = 'utf-8';
      request.headers['Accept'] = 'application/json; charset=utf-8';

      final response = await _defaultClient.send(request);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Explicitly decode response as UTF-8
        final responseBytes = await response.stream.toBytes();
        final responseData = utf8.decode(responseBytes);
        return responseData;
      }
      throw Exception('Failed with status: ${response.statusCode}');
    } on Exception catch (e) {
      print('ApiService.postMultipartJson Error: $e');
      rethrow;
    }
  }
}
