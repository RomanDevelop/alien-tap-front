import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';
import 'app/di/app_scope.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await GetStorage.init();
  } catch (e) {}

  AppConfig.logConfig();

  final apiBaseUrl = AppConfig.apiBaseUrl;

  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
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
