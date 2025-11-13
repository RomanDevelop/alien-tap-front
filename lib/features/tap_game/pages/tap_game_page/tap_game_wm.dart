// lib/features/tap_game/pages/tap_game_page/tap_game_wm.dart
import 'dart:async';

import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
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

  // Leaderboard
  final BehaviorSubject<List<LeaderboardEntry>> _leaderboard = BehaviorSubject.seeded([]);
  Stream<List<LeaderboardEntry>> get leaderboardStream => _leaderboard.stream;

  // Anti-cheat: client-side TPS limiter & cooldown
  final int maxTps = 15;
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);
  final Duration minTapInterval = Duration(milliseconds: 100); // 10 TPS baseline
  Timer? _autosaveTimer;
  int _lastSavedScore = 0;

  TapGameWidgetModel(this._repository, this._navigator, this.i18n, WidgetModelDependencies dependencies)
    : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadLeaderboard();
    _startAutosave();
  }

  @override
  void dispose() {
    _score.close();
    _isSaving.close();
    _leaderboard.close();
    _autosaveTimer?.cancel();
    super.dispose();
  }

  void onTap() {
    final now = DateTime.now();
    if (now.difference(_lastTap) < minTapInterval) {
      // Too fast — ignore
      _logger.w('Tap ignored: too fast');
      return;
    }
    _lastTap = now;
    _score.add(score + 1);

    // Save if reached threshold (every 10 points)
    if (score + 1 - _lastSavedScore >= 10) {
      _maybeSaveScore();
    }
  }

  void _startAutosave() {
    // Every 5 seconds, if score changed, try to push to server
    _autosaveTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      await _maybeSaveScore();
    });
  }

  Future<void> _maybeSaveScore() async {
    if (_isSaving.value == true) return;
    if (score == _lastSavedScore) return; // No changes

    _isSaving.add(true);
    try {
      await _repository.sendScore(score);
      _lastSavedScore = score;
      await _loadLeaderboard();
      _logger.d('Score saved: $score');
    } catch (e) {
      _logger.e('Failed to save score', error: e);
      // Log and ignore — backend will trust server-side checks
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
      // ignore
    }
  }

  void openLeaderboard() => _navigator.openLeaderboard();

  void openClaim() => _navigator.openClaim();
}
