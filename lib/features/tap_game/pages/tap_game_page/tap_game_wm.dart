import 'dart:async';

import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/features/tap_game/models/leaderboard_entry.dart';
import 'tap_game_i18n.dart';
import 'navigation/tap_game_navigator.dart';
import 'package:logger/logger.dart';

class TapGameWidgetModel extends WidgetModel {
  final TapRepository _repository;
  final TapGameNavigator _navigator;
  final TapGameI18n i18n;
  final Logger _logger = Logger();

  final BehaviorSubject<int> _score = BehaviorSubject.seeded(0);
  Stream<int> get scoreStream => _score.stream;
  int get score => _score.value;

  final BehaviorSubject<bool> _isSaving = BehaviorSubject.seeded(false);
  Stream<bool> get isSavingStream => _isSaving.stream;

  final BehaviorSubject<double> _alenBalance = BehaviorSubject.seeded(12450.0);
  Stream<double> get alenBalanceStream => _alenBalance.stream;
  double get alenBalance => _alenBalance.value;

  final BehaviorSubject<Map<String, dynamic>> _tokenFund = BehaviorSubject.seeded({
    'total': 900000000.0,
    'usdValue': 241430.0,
  });
  Stream<Map<String, dynamic>> get tokenFundStream => _tokenFund.stream;

  final BehaviorSubject<int> _sessionTapped = BehaviorSubject.seeded(0);
  Stream<int> get sessionTappedStream => _sessionTapped.stream;
  int get sessionTapped => _sessionTapped.value;

  DateTime _sessionStartTime = DateTime.now();
  Duration get sessionDuration => DateTime.now().difference(_sessionStartTime);

  final BehaviorSubject<double> _tradingBalance = BehaviorSubject.seeded(10000.0);
  Stream<double> get tradingBalanceStream => _tradingBalance.stream;
  double get tradingBalance => _tradingBalance.value;

  final BehaviorSubject<List<LeaderboardEntry>> _leaderboard = BehaviorSubject.seeded([]);
  Stream<List<LeaderboardEntry>> get leaderboardStream => _leaderboard.stream;

  final int maxTps = 15;
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);
  final Duration minTapInterval = Duration(milliseconds: 100);
  Timer? _autosaveTimer;
  int _lastSavedScore = 0;

  TapGameWidgetModel(this._repository, this._navigator, this.i18n, WidgetModelDependencies dependencies)
    : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadLeaderboard();
    _startAutosave();
    _sessionStartTime = DateTime.now();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {} catch (e) {
      _logger.e('Failed to load user data', error: e);
    }
  }

  @override
  void dispose() {
    _score.close();
    _isSaving.close();
    _leaderboard.close();
    _alenBalance.close();
    _tokenFund.close();
    _sessionTapped.close();
    _tradingBalance.close();
    _autosaveTimer?.cancel();
    super.dispose();
  }

  void onTap() {
    final now = DateTime.now();
    if (now.difference(_lastTap) < minTapInterval) {
      _logger.w('Tap ignored: too fast');
      return;
    }
    _lastTap = now;
    final newScore = score + 1;
    _score.add(newScore);

    _sessionTapped.add(sessionTapped + 1);
    _alenBalance.add(alenBalance + 1.0);

    if (newScore - _lastSavedScore >= 10) {
      _maybeSaveScore();
    }
  }

  void transferToTrading() {
    if (sessionTapped > 0) {
      _tradingBalance.add(tradingBalance + sessionTapped);
      _alenBalance.add(alenBalance - sessionTapped);
      _sessionTapped.add(0);
      _sessionStartTime = DateTime.now();
      _logger.d('Transferred $sessionTapped ALEN to trading balance');
    }
  }

  void openTrading() => _navigator.openTrading();
  void openPortfolio() => _navigator.openPortfolio();
  void openLiquidity() => _navigator.openLiquidity();
  void openProfile() => _navigator.openProfile();
  void openWithdraw() => _navigator.openWithdraw();

  void _startAutosave() {
    _autosaveTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      await _maybeSaveScore();
    });
  }

  Future<void> _maybeSaveScore() async {
    if (_isSaving.value == true) return;
    if (score == _lastSavedScore) return;

    _isSaving.add(true);
    try {
      await _repository.sendScore(score);
      _lastSavedScore = score;
      await _loadLeaderboard();
      _logger.d('Score saved: $score');
    } catch (e) {
      _logger.e('Failed to save score', error: e);
    } finally {
      _isSaving.add(false);
    }
  }

  Future<void> _loadLeaderboard() async {
    try {
      final lb = await _repository.getLeaderboard();
      _leaderboard.add(lb);
      _logger.d('Leaderboard loaded: ${lb.length} entries');
    } catch (e) {
      _logger.e('Failed to load leaderboard', error: e);
    }
  }

  void openLeaderboard() => _navigator.openLeaderboard();

  void openClaim() => _navigator.openClaim();

  Future<void> logout() async {
    try {
      _logger.d('Logging out...');
      await _repository.logout();

      await Future.delayed(const Duration(milliseconds: 200));

      final storage = GetStorage();
      for (int i = 0; i < 3; i++) {
        final token = storage.read<String>('jwt_token');
        if (token == null) {
          _logger.d('Token verified as cleared (attempt ${i + 1})');
          break;
        } else {
          _logger.w('Token still exists (attempt ${i + 1}), forcing removal');
          storage.remove('jwt_token');
          storage.remove('user_id');
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      final finalToken = storage.read<String>('jwt_token');
      if (finalToken != null) {
        _logger.e('CRITICAL: Token still exists after all attempts!');
        storage.remove('jwt_token');
        storage.remove('user_id');
        await Future.delayed(const Duration(milliseconds: 200));
      }

      _logger.d('Logout successful, redirecting to auth');
      _navigator.logout();
    } catch (e) {
      _logger.e('Logout failed', error: e);
      _navigator.logout();
    }
  }
}
