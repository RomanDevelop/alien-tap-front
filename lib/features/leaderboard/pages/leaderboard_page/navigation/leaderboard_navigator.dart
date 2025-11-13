// lib/features/leaderboard/pages/leaderboard_page/navigation/leaderboard_navigator.dart
import 'package:flutter/material.dart';

class LeaderboardNavigator {
  final NavigatorState _navigator;

  LeaderboardNavigator(BuildContext context) : _navigator = Navigator.of(context);

  void goBack() {
    _navigator.pop();
  }
}
