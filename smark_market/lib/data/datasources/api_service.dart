import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

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
          message: data['message'] ?? 'Éxito',
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: response.statusCode >= 200 && response.statusCode < 300,
          message: 'Éxito',
          data: {'results': data},
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error de conexión. Verifica tu red.',
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse<List<dynamic>>> searchProducts(String query) async {
    final url = '${AppConstants.baseUrl}/search?q=$query';
    print('Connecting to: $url');
    try {
      // Usar query parameter 'q' según el backend
      final response = await http
          .get(
            Uri.parse(url),
          )
          .timeout(
              const Duration(seconds: 45)); // Aumentar timeout para scraping

      print('Response Status: ${response.statusCode}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data is List) {
        return ApiResponse(
          success: true,
          message: 'Éxito',
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Error del servidor o formato inválido',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('Search Error: $e');
      return ApiResponse(
        success: false,
        message: 'Error de conexión. Verifica tu red.',
        statusCode: 0,
      );
    }
  }
}
