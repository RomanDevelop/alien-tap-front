// lib/features/tap_game/repositories/tap_repository.dart
import '../../../data/api/game_api.dart';
import '../models/leaderboard_entry.dart';

class TapRepository {
  final GameApi api;

  TapRepository({required this.api});

  Future<int> sendScore(int score) => api.updateScore(score);

  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final list = await api.getLeaderboard();
    return list.map((e) => LeaderboardEntry.fromJson(e)).toList();
  }

  Future<String> startClaim(double amount) => api.startClaim(amount);

  Future<void> confirmClaim(String claimId) => api.confirmClaim(claimId);

  Future<void> logout() async => api.logout();
}
