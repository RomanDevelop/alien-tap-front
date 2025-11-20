
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PortfolioNavigator {
  final BuildContext _context;

  PortfolioNavigator(this._context);

  void goBack() {
    _context.pop();
  }
}

