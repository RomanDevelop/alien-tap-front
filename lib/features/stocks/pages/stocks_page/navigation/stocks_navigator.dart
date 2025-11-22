import 'package:flutter/material.dart';

class UstocksNavigator {
  final BuildContext _context;
  UstocksNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
