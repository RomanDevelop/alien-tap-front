// lib/features/leaderboard/pages/leaderboard_page/leaderboard_page.dart
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/di/leaderboard_wm_builder.dart';
import 'package:alien_tap/features/tap_game/models/leaderboard_entry.dart';
import 'leaderboard_wm.dart';

class LeaderboardPage extends CoreMwwmWidget<LeaderboardWidgetModel> {
  LeaderboardPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createLeaderboardWidgetModel(ctx));

  @override
  WidgetState<LeaderboardPage, LeaderboardWidgetModel> createWidgetState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends WidgetState<LeaderboardPage, LeaderboardWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wm.i18n.pageTitle),
        actions: [
          StreamBuilder<bool>(
            stream: wm.isLoadingStream,
            initialData: false,
            builder: (ctx, snap) {
              if (snap.data == true) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              return IconButton(icon: const Icon(Icons.refresh), onPressed: wm.refresh);
            },
          ),
        ],
      ),
      body: StreamBuilder<bool>(
        stream: wm.isLoadingStream,
        initialData: false,
        builder: (ctx, loadingSnap) {
          final isLoading = loadingSnap.data ?? false;
          return StreamBuilder<List<LeaderboardEntry>>(
            stream: wm.leaderboardStream,
            initialData: [],
            builder: (ctx, snap) {
              final list = snap.data ?? [];
              if (list.isEmpty && !isLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.leaderboard_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(wm.i18n.emptyList, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: wm.refresh,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final entry = list[i];
                    final rank = i + 1;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: rank <= 3 ? Colors.amber : Colors.grey[300],
                        child: Text(
                          '$rank',
                          style: TextStyle(color: rank <= 3 ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(entry.displayName),
                      trailing: Text(
                        '${entry.score}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
