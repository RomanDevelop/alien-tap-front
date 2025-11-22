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

  static const String? debugJwtToken =
      kDebugMode
          ? 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4NjRjNWJiZi00N2IyLTRiY2ItOWI2NS03MmY0OGM0ZTRjZGUiLCJleHAiOjE3NjM4OTQwOTUsImlhdCI6MTc2MzgwNzY5NX0.Z_Z_ssmgD_0wKBPFS1NyCgq7kC3hAjNTQt1RQbMsW_I'
          : null;

  static const String? debugUserId = kDebugMode ? '864c5bbf-47b2-4bcb-9b65-72f48c4e4cde' : null;

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
