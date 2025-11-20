
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TradingNavigator {
  final BuildContext _context;

  TradingNavigator(this._context);

  void goBack() {
    _context.pop();
  }
}

