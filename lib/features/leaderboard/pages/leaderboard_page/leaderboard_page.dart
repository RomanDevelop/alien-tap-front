
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/di/leaderboard_wm_builder.dart';
import 'package:alien_tap/features/tap_game/models/leaderboard_entry.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
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
      body: Container(
        decoration: NeonTheme.backgroundGradient,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    NeonTheme.darkSurface,
                    NeonTheme.darkCard,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: NeonTheme.neonPurple.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: AppBar(
                title: Text(
                  wm.i18n.pageTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    shadows: NeonTheme.neonTextShadow,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  StreamBuilder<bool>(
                    stream: wm.isLoadingStream,
                    initialData: false,
                    builder: (ctx, snap) {
                      if (snap.data == true) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.neonCyan),
                            ),
                          ),
                        );
                      }
                      return IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: wm.refresh,
                        color: NeonTheme.neonCyan,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<bool>(
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
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      NeonTheme.neonPurple.withOpacity(0.3),
                                      NeonTheme.neonCyan.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.leaderboard_outlined,
                                  size: 64,
                                  color: NeonTheme.neonCyan,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                wm.i18n.emptyList,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: wm.refresh,
                        backgroundColor: NeonTheme.darkCard,
                        color: NeonTheme.neonCyan,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final entry = list[i];
                            final rank = i + 1;
                            final isTopThree = rank <= 3;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                gradient: isTopThree
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          NeonTheme.neonPurple.withOpacity(0.3),
                                          NeonTheme.neonCyan.withOpacity(0.3),
                                        ],
                                      )
                                    : null,
                                color: isTopThree ? null : NeonTheme.darkCard,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isTopThree
                                      ? NeonTheme.neonCyan.withOpacity(0.5)
                                      : NeonTheme.neonCyan.withOpacity(0.2),
                                  width: isTopThree ? 2 : 1,
                                ),
                                boxShadow: isTopThree
                                    ? [
                                        BoxShadow(
                                          color: NeonTheme.neonCyan.withOpacity(0.3),
                                          blurRadius: 15,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isTopThree
                                        ? LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: rank == 1
                                                ? [NeonTheme.neonGreen, NeonTheme.neonCyan]
                                                : rank == 2
                                                    ? [NeonTheme.neonCyan, NeonTheme.neonBlue]
                                                    : [NeonTheme.neonPurple, NeonTheme.neonPink],
                                          )
                                        : null,
                                    color: isTopThree ? null : NeonTheme.darkSurface,
                                    boxShadow: isTopThree
                                        ? [
                                            BoxShadow(
                                              color: (rank == 1
                                                      ? NeonTheme.neonGreen
                                                      : rank == 2
                                                          ? NeonTheme.neonCyan
                                                          : NeonTheme.neonPurple)
                                                  .withOpacity(0.5),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$rank',
                                      style: TextStyle(
                                        color: isTopThree ? NeonTheme.darkBackground : NeonTheme.lightText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  entry.displayName,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isTopThree ? NeonTheme.neonCyan : NeonTheme.lightText,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        NeonTheme.neonCyan.withOpacity(0.3),
                                        NeonTheme.neonPurple.withOpacity(0.3),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: NeonTheme.neonCyan.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${entry.score}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: NeonTheme.neonCyan,
                                      shadows: NeonTheme.neonTextShadow,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
