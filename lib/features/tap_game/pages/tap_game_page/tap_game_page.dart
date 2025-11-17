// lib/features/tap_game/pages/tap_game_page/tap_game_page.dart
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'tap_game_wm.dart';
import 'di/tap_game_wm_builder.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';

class TapGamePage extends CoreMwwmWidget<TapGameWidgetModel> {
  final TapRepository repository;

  TapGamePage({required this.repository, Key? key})
    : super(key: key, widgetModelBuilder: (ctx) => createTapGameWidgetModel(ctx, repository: repository));

  @override
  WidgetState<TapGamePage, TapGameWidgetModel> createWidgetState() => _TapGamePageState();
}

class _TapGamePageState extends WidgetState<TapGamePage, TapGameWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: NeonTheme.backgroundGradient,
        child: Column(
          children: [
            // AppBar с градиентом
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [NeonTheme.darkSurface, NeonTheme.darkCard],
                ),
                boxShadow: [BoxShadow(color: NeonTheme.neonCyan.withOpacity(0.2), blurRadius: 10, spreadRadius: 1)],
              ),
              child: AppBar(
                title: Text(
                  wm.i18n.pageTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(shadows: NeonTheme.neonTextShadow),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  StreamBuilder<bool>(
                    stream: wm.isSavingStream,
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
                      return const SizedBox.shrink();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.logout),
                    tooltip: wm.i18n.logoutButton,
                    onPressed: wm.logout,
                    color: Colors.red.shade400,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Score display с неоновым эффектом
                      StreamBuilder<int>(
                        stream: wm.scoreStream,
                        initialData: wm.score,
                        builder: (ctx, snap) {
                          final score = snap.data ?? 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [NeonTheme.neonPurple.withOpacity(0.2), NeonTheme.neonCyan.withOpacity(0.2)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: NeonTheme.neonCyan.withOpacity(0.5), width: 2),
                              boxShadow: NeonTheme.neonGlow,
                            ),
                            child: Column(
                              children: [
                                Text(wm.i18n.scoreLabel, style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                Text(
                                  '${score}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayMedium?.copyWith(shadows: NeonTheme.neonTextShadow),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 60),
                      // Tap button с неоновым эффектом
                      GestureDetector(
                        onTap: wm.onTap,
                        child: Container(
                          height: 180,
                          width: 180,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [NeonTheme.neonCyan, NeonTheme.neonPurple, NeonTheme.neonPink],
                              stops: [0.0, 0.5, 1.0],
                            ),
                            boxShadow: [
                              ...NeonTheme.neonGlow,
                              BoxShadow(color: NeonTheme.neonPink.withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                            ],
                          ),
                          child: Text(
                            wm.i18n.tapButton,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: NeonTheme.darkBackground,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Buttons row с неоновыми стилями
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: NeonTheme.buttonGradient,
                              child: ElevatedButton.icon(
                                onPressed: wm.openLeaderboard,
                                icon: const Icon(Icons.leaderboard, size: 24),
                                label: Text(
                                  wm.i18n.leaderboardButton,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: NeonTheme.darkBackground,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [NeonTheme.neonPink, NeonTheme.neonPurple],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: NeonTheme.neonPinkGlow,
                              ),
                              child: ElevatedButton.icon(
                                onPressed: wm.openClaim,
                                icon: const Icon(Icons.monetization_on, size: 24),
                                label: Text(
                                  wm.i18n.startClaimButton,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
