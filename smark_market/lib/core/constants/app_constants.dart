import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Android emulator uses 10.0.2.2, iOS simulator uses localhost
  static String get baseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_BASE_URL no encontrada en el archivo .env');
    }
    return url;
  }

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static const String searchEndpoint = '/products/search';

  static const String appName = 'Smart Market';
}
