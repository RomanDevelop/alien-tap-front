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

  void navigateToClaim() {
    context.go('/claim');
  }

  void navigateToLiquidity() {
    context.go('/liquidity');
  }

  void logout() {
    final storage = GetStorage();
    storage.remove('jwt_token');
    AppRouter.invalidateAuthCache();
    context.go('/auth');
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
