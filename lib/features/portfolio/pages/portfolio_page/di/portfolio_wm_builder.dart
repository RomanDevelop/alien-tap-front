// lib/features/portfolio/pages/portfolio_page/di/portfolio_wm_builder.dart
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import '../portfolio_wm.dart';
import '../portfolio_i18n.dart';
import '../navigation/portfolio_navigator.dart';
import '../../../../portfolio/repositories/portfolio_repository.dart';

PortfolioWidgetModel createPortfolioWidgetModel(BuildContext context) {
  final i18n = PortfolioI18n();
  final navigator = PortfolioNavigator(context);
  final repository = PortfolioRepository();
  return PortfolioWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}

