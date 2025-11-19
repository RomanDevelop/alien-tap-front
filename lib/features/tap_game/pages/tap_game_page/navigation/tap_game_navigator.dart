// lib/features/tap_game/pages/tap_game_page/navigation/tap_game_navigator.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TapGameNavigator {
  final BuildContext _context;

  TapGameNavigator(this._context);

  void openLeaderboard() {
    _context.push('/leaderboard');
  }

  void openClaim() {
    _context.push('/claim');
  }

  void openTrading() {
    _context.push('/trading');
  }

  void openPortfolio() {
    _context.push('/portfolio');
  }

  void openLiquidity() {
    _context.push('/liquidity');
  }

  void openProfile() {
    _context.push('/profile');
  }

  void openWithdraw() {
    _context.push('/claim');
  }

  void logout() {
    _context.go('/auth');
  }
}
