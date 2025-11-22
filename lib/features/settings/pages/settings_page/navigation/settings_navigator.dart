import 'package:flutter/material.dart';

class SettingsNavigator {
  final BuildContext _context;
  SettingsNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
