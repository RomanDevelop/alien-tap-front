// lib/features/liquidity/pages/liquidity_page/di/liquidity_wm_builder.dart
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import '../liquidity_wm.dart';
import '../liquidity_i18n.dart';
import '../navigation/liquidity_navigator.dart';
import '../../../../liquidity/repositories/liquidity_repository.dart';

LiquidityWidgetModel createLiquidityWidgetModel(BuildContext context) {
  final i18n = LiquidityI18n();
  final navigator = LiquidityNavigator(context);
  final repository = LiquidityRepository();
  return LiquidityWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}

