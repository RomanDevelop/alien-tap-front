import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import '../settings_wm.dart';
import '../settings_i18n.dart';
import '../navigation/settings_navigator.dart';
import '../../../../settings/repositories/settings_repository.dart';

SettingsWidgetModel createSettingsWidgetModel(BuildContext context) {
  final i18n = SettingsI18n();
  final navigator = SettingsNavigator(context);
  final repository = SettingsRepository();
  return SettingsWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}
