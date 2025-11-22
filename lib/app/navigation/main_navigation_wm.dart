import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alien_tap/app/router/app_router.dart';
import 'main_navigation_i18n.dart';

class MainNavigationWidgetModel extends WidgetModel {
  final BuildContext context;
  final MainNavigationI18n i18n;

  final BehaviorSubject<int> _selectedIndex = BehaviorSubject.seeded(0);
  Stream<int> get selectedIndexStream => _selectedIndex.stream;
  int get selectedIndex => _selectedIndex.value;

  MainNavigationWidgetModel(this.context, this.i18n, WidgetModelDependencies dependencies) : super(dependencies);

  static const List<String> _routes = ['/game', '/trading', '/portfolio', '/leaderboard'];

  void onTabTapped(int index) {
    if (index == _selectedIndex.value || index >= _routes.length) return;
    _selectedIndex.add(index);
    context.go(_routes[index]);
  }

  void navigateToProfile() {
    context.go('/profile');
  }

  void navigateToWallet() {
    context.go('/wallet');
  }

  void navigateToSettings() {
    context.go('/settings');
  }

  void navigateToNews() {
    context.go('/news');
  }

  void navigateToSignals() {
    context.go('/signals');
  }

  void navigateToCalendar() {
    context.go('/calendar');
  }

  void navigateToSubscription() {
    context.go('/subscription');
  }

  void navigateToEducation() {
    context.go('/education');
  }

  void navigateToCrypto() {
    context.go('/crypto');
  }

  void navigateToStocks() {
    context.go('/stocks');
  }

  void navigateToForex() {
    context.go('/forex');
  }

  void navigateToCommodities() {
    context.go('/commodities');
  }

  void navigateToOptions() {
    context.go('/options');
  }

  void updateSelectedIndex(String currentPath) {
    final index = _routes.indexOf(currentPath);
    if (index != -1 && index != _selectedIndex.value) {
      _selectedIndex.add(index);
    }
  }

  @override
  void dispose() {
    _selectedIndex.close();
    super.dispose();
  }
}
