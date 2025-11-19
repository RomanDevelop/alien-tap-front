// lib/features/trading/pages/trading_page/di/trading_wm_builder.dart
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import '../trading_wm.dart';
import '../trading_i18n.dart';
import '../navigation/trading_navigator.dart';
import '../../../../trading/repositories/trading_repository.dart';

TradingWidgetModel createTradingWidgetModel(BuildContext context) {
  final i18n = TradingI18n();
  final navigator = TradingNavigator(context);
  final repository = TradingRepository();
  return TradingWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}

