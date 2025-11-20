
import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/features/tap_game/models/leaderboard_entry.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/leaderboard_i18n.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/navigation/leaderboard_navigator.dart';
import 'package:logger/logger.dart';

class LeaderboardWidgetModel extends WidgetModel {
  final TapRepository _repository;
  final LeaderboardNavigator _navigator;
  final LeaderboardI18n i18n;
  final Logger _logger = Logger();

  final BehaviorSubject<List<LeaderboardEntry>> _leaderboard = BehaviorSubject.seeded([]);
  Stream<List<LeaderboardEntry>> get leaderboardStream => _leaderboard.stream;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;

  LeaderboardWidgetModel(this._repository, this._navigator, this.i18n, WidgetModelDependencies dependencies)
    : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    _isLoading.add(true);
    try {
      final lb = await _repository.getLeaderboard();
      _leaderboard.add(lb);
      _logger.d('Leaderboard loaded: ${lb.length} entries');
    } catch (e) {
      _logger.e('Failed to load leaderboard', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> refresh() async {
    await _loadLeaderboard();
  }

  @override
  void dispose() {
    _leaderboard.close();
    _isLoading.close();
    super.dispose();
  }
}
