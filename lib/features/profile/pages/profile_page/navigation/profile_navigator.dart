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
    _context.go('/auth');
  }
}

