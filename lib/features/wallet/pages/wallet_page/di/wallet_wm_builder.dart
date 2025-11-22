import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import '../wallet_wm.dart';
import '../wallet_i18n.dart';
import '../navigation/wallet_navigator.dart';
import '../../../../wallet/repositories/wallet_repository.dart';

WalletWidgetModel createWalletWidgetModel(BuildContext context) {
  final i18n = WalletI18n();
  final navigator = WalletNavigator(context);
  final repository = WalletRepository();
  return WalletWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}
