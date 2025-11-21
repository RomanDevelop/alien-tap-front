import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'dart:ui' show PlatformDispatcher;
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';
import 'app/di/app_scope.dart';
import 'config/app_config.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await GetStorage.init();
  } catch (e) {}

  AppConfig.logConfig();

  final apiBaseUrl = AppConfig.apiBaseUrl;

  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      if (kIsWeb) {
        developer.log(
          'Flutter Error: ${details.exception}',
          name: 'FlutterError',
          error: details.exception,
          stackTrace: details.stack,
        );
        developer.log('Error summary: ${details.summary}', name: 'FlutterError');
      } else {
        try {
          FlutterError.presentError(details);
        } catch (e) {
          developer.log(
            'Flutter Error: ${details.exception}',
            name: 'FlutterError',
            error: details.exception,
            stackTrace: details.stack,
          );
        }
      }
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  try {
    await setupAppScope(apiBaseUrl: apiBaseUrl);
  } catch (e) {}

  runApp(const AlienTapApp());
}
