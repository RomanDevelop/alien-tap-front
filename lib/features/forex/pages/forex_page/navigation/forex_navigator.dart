import 'package:flutter/material.dart';

class UforexNavigator {
  final BuildContext _context;
  UforexNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
