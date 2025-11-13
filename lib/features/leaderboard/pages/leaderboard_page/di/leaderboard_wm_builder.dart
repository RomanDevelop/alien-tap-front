// lib/features/leaderboard/pages/leaderboard_page/di/leaderboard_wm_builder.dart
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/leaderboard_wm.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/leaderboard_i18n.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/navigation/leaderboard_navigator.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/app/di/app_scope.dart';

LeaderboardWidgetModel createLeaderboardWidgetModel(BuildContext context) {
  final repository = locator<TapRepository>();
  final navigator = LeaderboardNavigator(context);
  final i18n = LeaderboardI18n();

  return LeaderboardWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}
