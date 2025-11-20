// lib/features/profile/pages/profile_page/navigation/profile_navigator.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileNavigator {
  final BuildContext _context;

  ProfileNavigator(this._context);

  void goBack() {
    _context.pop();
  }

  void logout() {
    print('🚪 ProfileNavigator.logout() called - redirecting to /auth');
    try {
      _context.go('/auth');
      print('✅ Navigation to /auth initiated');
    } catch (e) {
      print('❌ Navigation error: $e');
      // Fallback: try push instead of go
      try {
        _context.push('/auth');
        print('✅ Navigation via push succeeded');
      } catch (e2) {
        print('❌ Push navigation also failed: $e2');
      }
    }
  }
}

