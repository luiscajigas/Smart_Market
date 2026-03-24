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

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse(
        success: data['success'] ?? false,
        message: data['message'] ?? 'Error desconocido',
        data: data['data'] as Map<String, dynamic>?,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error de conexión. Verifica tu red.',
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.searchEndpoint}?query=$query'),
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      // FastAPI backend returns the data directly as the body
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode == 200 ? 'Éxito' : 'Error del servidor',
        data: data,
        statusCode: response.statusCode,
      );
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