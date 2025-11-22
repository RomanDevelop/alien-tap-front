import 'package:flutter/material.dart';

class UoptionsNavigator {
  final BuildContext _context;
  UoptionsNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
