import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileNavigator {
  final BuildContext _context;

  ProfileNavigator(this._context);

  void goBack() {
    _context.pop();
  }

  void logout() {
    try {
      _context.go('/auth');
    } catch (e) {
      try {
        _context.push('/auth');
      } catch (e2) {}
    }
  }
}
