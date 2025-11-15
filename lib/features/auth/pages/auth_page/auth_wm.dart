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
    if (_isLoading.value == true) {
      print('⚠️ authenticate() called but already loading, ignoring...');
      _logger.d('⚠️ authenticate() called but already loading, ignoring...');
      return;
    }

    print('🔍 authenticate() called - starting authentication process...');
    // Use JS console.log for guaranteed visibility
    try {
      // @JS interop would require import, using window.console directly via JS
      // For now, print should work, but let's also add a visual indicator
    } catch (e) {
      // Ignore
    }
    _logger.d('🔍 authenticate() called - starting authentication process...');
    _isLoading.add(true);
    _error.add(null);

    try {
      print('📤 Calling _api.authenticate()...');
      _logger.d('📤 Calling _api.authenticate()...');
      await _api.authenticate();
      print('✅ Authentication successful - token received');
      _logger.d('✅ Authentication successful - token received');

      // Небольшая задержка, чтобы токен точно сохранился
      await Future.delayed(const Duration(milliseconds: 100));

      // Проверяем, что токен действительно сохранен
      try {
        final token = (_api as dynamic)._token;
        if (token != null && token.toString().isNotEmpty) {
          _logger.d('✅ Token verified in storage (length: ${token.toString().length})');
        } else {
          _logger.w('⚠️ Token not found in storage after authentication!');
        }
      } catch (e) {
        _logger.w('⚠️ Could not verify token: $e');
      }

      // Переход на игровой экран
      _logger.d('🔄 Navigating to game screen...');
      _navigator.goToGame();
    } catch (e, stackTrace) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      _error.add(errorMsg);
      _logger.e('❌ Authentication failed: $e');
      _logger.e('   Stack trace: $stackTrace');
      print('❌ AuthWidgetModel.authenticate() error: $e');
      print('   Stack: $stackTrace');
    } finally {
      _isLoading.add(false);
      _logger.d('🏁 authenticate() completed');
    }
  }

  @override
  void dispose() {
    _isLoading.close();
    _error.close();
    super.dispose();
  }
}
