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

      Future.delayed(const Duration(milliseconds: 200), () {
        try {
          if (_context.mounted) {
            _context.go('/auth');
          }
        } catch (e) {}
      });
    } catch (e) {
      try {
        _context.push('/auth');
      } catch (e2) {}
    }
  }
}
