import 'package:flutter/material.dart';

class NewsNavigator {
  final BuildContext _context;
  NewsNavigator(this._context);
  void goBack() => Navigator.of(_context).pop();
}
