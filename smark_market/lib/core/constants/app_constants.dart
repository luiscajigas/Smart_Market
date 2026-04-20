import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get baseUrl {
    String url = dotenv.env['API_BASE_URL'] ?? '';
    if (url.isEmpty) {
      throw Exception('API_BASE_URL no encontrada en el archivo .env');
    }

    // Android emulator mapping - Only check Platform if NOT on Web
    if (!kIsWeb) {
      if (Platform.isAndroid &&
          (url.contains('localhost') || url.contains('127.0.0.1'))) {
        return url
            .replaceFirst('localhost', '10.0.2.2')
            .replaceFirst('127.0.0.1', '10.0.2.2');
      }
    }

    return url;
  }

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static const String searchEndpoint = '/products/search';

  static const String appName = 'Smart Market';
}
