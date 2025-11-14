// lib/config/app_config.dart
import 'package:flutter/foundation.dart';

/// Конфигурация приложения для разных окружений
class AppConfig {
  /// Базовый URL API
  ///
  /// Использование:
  /// - Development (локально): 'http://localhost:8000'
  /// - Development (ngrok): 'https://your-ngrok-url.ngrok-free.dev'
  /// - Production: 'https://your-backend-url.railway.app'
  static String get apiBaseUrl {
    // Проверяем переменную окружения (приоритет)
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    // Для production используем production URL
    const isProd = bool.fromEnvironment('PRODUCTION', defaultValue: false);
    if (isProd) {
      return 'https://your-backend-url.railway.app'; // TODO: Замените на ваш production URL
    }

    // Для разработки используем localhost
    if (kDebugMode) {
      return 'http://localhost:8000';
    }

    // Fallback
    return 'http://localhost:8000';
  }

  /// Флаг production окружения (const, вычисляется при компиляции)
  static const bool isProduction = bool.fromEnvironment('PRODUCTION', defaultValue: false);

  /// Флаг development окружения
  static bool get isDevelopment => !isProduction;

  /// Логирование конфигурации (для отладки)
  static void logConfig() {
    if (kDebugMode) {
      print('🔧 AppConfig:');
      print('   API Base URL: $apiBaseUrl');
      print('   Is Production: $isProduction');
      print('   Is Development: $isDevelopment');
    }
  }
}
