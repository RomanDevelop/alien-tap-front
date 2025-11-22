import 'package:flutter/material.dart';

class WalletNavigator {
  final BuildContext _context;

  WalletNavigator(this._context);

  void goBack() {
    Navigator.of(_context).pop();
  }
}
