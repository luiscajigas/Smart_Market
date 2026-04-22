import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_messages.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.statusCode,
  });
}

class ApiService {
  static Future<ApiResponse<Map<String, dynamic>>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await http
          .post(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return ApiResponse(
          success: data['success'] ??
              (response.statusCode >= 200 && response.statusCode < 300),
          message: data['message'] ?? 'Success',
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: response.statusCode >= 200 && response.statusCode < 300,
          message: 'Success',
          data: {'results': data},
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Connection error. Check your network.',
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse<List<dynamic>>> searchProducts(String query) async {
    final url = '${AppConstants.baseUrl}/search?q=$query';
    debugPrint('Connecting to: $url');
    try {
      // Use query parameter 'q' according to the backend
      final response = await http
          .get(
            Uri.parse(url),
          )
          .timeout(
              const Duration(seconds: 45)); // Increase timeout for scraping

      debugPrint('Response Status: ${response.statusCode}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data is List) {
        return ApiResponse(
          success: true,
          message: 'Success',
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          message: AppMessages.serverError,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Search Error: $e');
      return ApiResponse(
        success: false,
        message: AppMessages.connectionError,
        statusCode: 0,
      );
    }
  }
}
