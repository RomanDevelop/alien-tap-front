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
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = (_api as dynamic)._token;
      if (token != null && (token as String).isNotEmpty) {
        _navigator.goToGame();
      }
    } catch (e) {
      _logger.d('No existing token found');
    }
  }

  Future<void> authenticate() async {
    if (_isLoading.value == true) {
      _logger.d('authenticate() called but already loading, ignoring...');
      return;
    }
    try {} catch (e) {}
    _logger.d('🔍 authenticate() called - starting authentication process...');
    _isLoading.add(true);
    _error.add(null);

    try {
      _logger.d('Calling _api.authenticate()...');
      await _api.authenticate();
      _logger.d('Authentication successful - token received');
      _logger.d('Navigating to game screen...');
      _navigator.goToGame();
    } catch (e, stackTrace) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      _error.add(errorMsg);
      _logger.e('Authentication failed: $e');
      _logger.e('Stack trace: $stackTrace');
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
