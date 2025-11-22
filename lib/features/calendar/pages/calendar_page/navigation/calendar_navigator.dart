import 'package:flutter/material.dart';

class UcalendarNavigator {
  final BuildContext _context;
  UcalendarNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
