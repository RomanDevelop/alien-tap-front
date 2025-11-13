// lib/features/auth/pages/auth_page/di/auth_wm_builder.dart
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/data/api/game_api.dart';
import 'package:alien_tap/features/auth/pages/auth_page/auth_wm.dart';
import 'package:alien_tap/features/auth/pages/auth_page/auth_i18n.dart';
import 'package:alien_tap/features/auth/pages/auth_page/navigation/auth_navigator.dart';
import 'package:alien_tap/app/di/app_scope.dart';

AuthWidgetModel createAuthWidgetModel(BuildContext context) {
  final api = locator<GameApi>();
  final navigator = AuthNavigator(context);
  final i18n = AuthI18n();

  return AuthWidgetModel(api, navigator, i18n, WidgetModelDependencies());
}
