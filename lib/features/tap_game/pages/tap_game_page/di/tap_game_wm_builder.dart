// lib/features/tap_game/pages/tap_game_page/di/tap_game_wm_builder.dart
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import '../tap_game_wm.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import '../tap_game_i18n.dart';
import '../navigation/tap_game_navigator.dart';

TapGameWidgetModel createTapGameWidgetModel(BuildContext context, {required TapRepository repository}) {
  final i18n = TapGameI18n();
  final navigator = TapGameNavigator(context);
  return TapGameWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}
