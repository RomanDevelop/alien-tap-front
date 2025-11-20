import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthNavigator {
  final BuildContext _context;

  AuthNavigator(this._context);

  void goToGame() {
    try {
      _context.go('/game');
    } catch (e) {
      try {
        _context.push('/game');
      } catch (e2) {}
    }
  }
}
