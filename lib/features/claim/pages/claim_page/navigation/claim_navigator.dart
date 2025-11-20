
import 'package:flutter/material.dart';

class ClaimNavigator {
  final NavigatorState _navigator;

  ClaimNavigator(BuildContext context) : _navigator = Navigator.of(context);

  void goBack() {
    _navigator.pop();
  }

  void showError(String error) {
    ScaffoldMessenger.of(_navigator.context).showSnackBar(SnackBar(content: Text(error)));
  }
}
