import 'package:flutter/material.dart';

class UcryptoNavigator {
  final BuildContext _context;
  UcryptoNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
