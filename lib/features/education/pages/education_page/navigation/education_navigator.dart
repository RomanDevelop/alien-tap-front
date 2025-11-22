import 'package:flutter/material.dart';

class UeducationNavigator {
  final BuildContext _context;
  UeducationNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
