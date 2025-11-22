import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    const isProd = bool.fromEnvironment('PRODUCTION', defaultValue: false);
    if (isProd) {
      return 'https://your-backend-url.railway.app';
    }

    if (kDebugMode) {
      return 'http://localhost:8000';
    }

    return 'http://localhost:8000';
  }

  static const bool isProduction = bool.fromEnvironment('PRODUCTION', defaultValue: false);

  static bool get isDevelopment => !isProduction;

  static const String? debugJwtToken = kDebugMode ? '' : null;

  static const String? debugUserId = kDebugMode ? '' : null;

  static bool get isDebugMode => kDebugMode && !isProduction;

  static void logConfig() {
    if (kDebugMode) {
      print('🔧 AppConfig:');
      print('   - Debug Mode: ${kDebugMode}');
      print('   - Production: $isProduction');
      print('   - Development: $isDevelopment');
      print('   - API Base URL: $apiBaseUrl');
      print('   - Debug Token Available: ${debugJwtToken != null}');
      print('   - Debug User ID: $debugUserId');
    }
  }
}
