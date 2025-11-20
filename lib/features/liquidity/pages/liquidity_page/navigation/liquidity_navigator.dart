
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LiquidityNavigator {
  final BuildContext _context;

  LiquidityNavigator(this._context);

  void goBack() {
    _context.pop();
  }
}

