// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';
import 'app/di/app_scope.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем GetStorage ПЕРВЫМ (нужно для роутера)
  try {
    await GetStorage.init();
    if (kDebugMode) {
      print('✅ GetStorage initialized');
  }
  } catch (e) {
    if (kDebugMode) {
      print('⚠️ GetStorage init warning: $e');
    }
    // Продолжаем даже если GetStorage не инициализирован
  }

  // Логируем конфигурацию для отладки
  AppConfig.logConfig();

  // Получаем API URL из конфигурации
  final apiBaseUrl = AppConfig.apiBaseUrl;

  // Настраиваем обработку ошибок Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
      print('❌ Flutter Error: ${details.exception}');
      print('Stack: ${details.stack}');
  }
  };

  // Настраиваем обработку ошибок платформы
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      print('❌ Platform Error: $error');
      print('Stack: $stack');
    }
    return true;
  };

  try {
    await setupAppScope(apiBaseUrl: apiBaseUrl);
    if (kDebugMode) {
      print('✅ App scope setup completed');
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('❌ Error initializing app scope: $e');
      print('StackTrace: $stackTrace');
    }
    // Continue anyway - authentication will happen when needed
  }

  runApp(const AlienTapApp());
}
