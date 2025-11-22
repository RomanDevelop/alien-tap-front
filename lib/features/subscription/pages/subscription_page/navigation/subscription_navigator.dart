import 'package:flutter/material.dart';

class UsubscriptionNavigator {
  final BuildContext _context;
  UsubscriptionNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
