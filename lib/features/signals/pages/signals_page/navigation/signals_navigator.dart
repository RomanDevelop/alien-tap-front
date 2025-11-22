import 'package:flutter/material.dart';

class UsignalsNavigator {
  final BuildContext _context;
  UsignalsNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
