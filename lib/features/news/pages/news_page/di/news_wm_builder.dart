import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import '../news_wm.dart';
import '../news_i18n.dart';
import '../navigation/news_navigator.dart';
import '../../../../news/repositories/news_repository.dart';

NewsWidgetModel createNewsWidgetModel(BuildContext context) {
  final i18n = NewsI18n();
  final navigator = NewsNavigator(context);
  final repository = NewsRepository();
  return NewsWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}
