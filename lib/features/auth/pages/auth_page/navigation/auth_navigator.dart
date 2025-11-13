// lib/features/auth/pages/auth_page/navigation/auth_navigator.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthNavigator {
  final BuildContext _context;

  AuthNavigator(this._context);

  void goToGame() {
    print('🚀 AuthNavigator.goToGame() called');
    try {
      _context.go('/game');
      print('✅ Navigation to /game initiated');
    } catch (e) {
      print('❌ Navigation error: $e');
      // Fallback: try push instead of go
      try {
        _context.push('/game');
        print('✅ Navigation via push succeeded');
      } catch (e2) {
        print('❌ Push navigation also failed: $e2');
      }
    }
  }
}
