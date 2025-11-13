// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'app/app.dart';
import 'app/di/app_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Replace with your actual API base URL
  // For local development: 'http://localhost:8000'
  // For production: 'https://your-domain.com'
  const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000');

  try {
    await setupAppScope(apiBaseUrl: apiBaseUrl);
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error initializing app scope: $e');
      print('StackTrace: $stackTrace');
    }
    // Continue anyway - authentication will happen when needed
  }

  runApp(const AlienTapApp());
}
