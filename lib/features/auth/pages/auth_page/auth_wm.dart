// lib/features/auth/pages/auth_page/auth_wm.dart
import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:alien_tap/data/api/game_api.dart';
import 'package:alien_tap/features/auth/pages/auth_page/auth_i18n.dart';
import 'package:alien_tap/features/auth/pages/auth_page/navigation/auth_navigator.dart';
import 'package:logger/logger.dart';

class AuthWidgetModel extends WidgetModel {
  final GameApi _api;
  final AuthNavigator _navigator;
  final AuthI18n i18n;
  final Logger _logger = Logger();

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;

  final BehaviorSubject<String?> _error = BehaviorSubject.seeded(null);
  Stream<String?> get errorStream => _error.stream;

  AuthWidgetModel(this._api, this._navigator, this.i18n, WidgetModelDependencies dependencies) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    // Проверяем, может быть уже авторизован
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Проверяем наличие токена
      final token = (_api as dynamic)._token;
      if (token != null && (token as String).isNotEmpty) {
        // Уже авторизован, переходим на игровой экран
        _navigator.goToGame();
      }
    } catch (e) {
      _logger.d('No existing token found');
    }
  }

  Future<void> authenticate() async {
    if (_isLoading.value == true) return;

    _isLoading.add(true);
    _error.add(null);

    try {
      await _api.authenticate();
      _logger.d('Authentication successful');

      // Небольшая задержка, чтобы токен точно сохранился
      await Future.delayed(const Duration(milliseconds: 100));

      // Переход на игровой экран
      _logger.d('Navigating to game screen...');
      _navigator.goToGame();
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      _error.add(errorMsg);
      _logger.e('Authentication failed: $e');
    } finally {
      _isLoading.add(false);
    }
  }

  @override
  void dispose() {
    _isLoading.close();
    _error.close();
    super.dispose();
  }
}
