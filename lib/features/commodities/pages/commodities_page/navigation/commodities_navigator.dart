import 'package:flutter/material.dart';

class UcommoditiesNavigator {
  final BuildContext _context;
  UcommoditiesNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
