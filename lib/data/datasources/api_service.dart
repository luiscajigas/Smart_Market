import 'dart:convert';
import 'dart:async';
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

  static Future<ApiResponse<List<dynamic>>> searchProducts(
    String query, {
    String? userId,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}/search').replace(
        queryParameters: {
          'q': query,
          if (userId != null && userId.trim().isNotEmpty) 'user_id': userId,
        },
      );

      final response = await http
          .get(
            uri,
          )
          .timeout(
              const Duration(seconds: 90)); // Increase timeout for scraping

      dynamic decoded;
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = null;
      }

      if (response.statusCode == 200 && decoded is List) {
        return ApiResponse(
          success: true,
          message: 'Success',
          data: decoded,
          statusCode: response.statusCode,
        );
      }

      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail']?.toString();
        return ApiResponse(
          success: false,
          message: detail?.isNotEmpty == true
              ? detail!
              : '${AppMessages.serverError} (HTTP ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }

      final bodyPreview = response.body.trim().isEmpty
          ? ''
          : response.body.trim().substring(
                0,
                response.body.trim().length > 160
                    ? 160
                    : response.body.trim().length,
              );

      return ApiResponse(
        success: false,
        message: bodyPreview.isEmpty
            ? '${AppMessages.serverError} (HTTP ${response.statusCode})'
            : '${AppMessages.serverError} (HTTP ${response.statusCode}): $bodyPreview',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      return ApiResponse(
        success: false,
        message: AppMessages.serverError,
        statusCode: 408,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString().contains('SocketException')
            ? AppMessages.connectionError
            : AppMessages.serverError,
        statusCode: 0,
      );
    }
  }
}
