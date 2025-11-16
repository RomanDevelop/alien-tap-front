// lib/features/tap_game/pages/tap_game_page/tap_game_page.dart
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'tap_game_wm.dart';
import 'di/tap_game_wm_builder.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';

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
      appBar: AppBar(
        title: Text(wm.i18n.pageTitle),
        actions: [
          StreamBuilder<bool>(
            stream: wm.isSavingStream,
            initialData: false,
            builder: (ctx, snap) {
              if (snap.data == true) {
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              return SizedBox.shrink();
            },
          ),
          IconButton(icon: Icon(Icons.logout, color: Colors.red), tooltip: wm.i18n.logoutButton, onPressed: wm.logout),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Score display
          StreamBuilder<int>(
            stream: wm.scoreStream,
            initialData: wm.score,
            builder:
                (ctx, snap) => Text(
                  '${wm.i18n.scoreLabel}: ${snap.data ?? 0}',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
          ),
          SizedBox(height: 40),
          // Tap button
          GestureDetector(
            onTap: wm.onTap,
            child: Container(
              height: 150,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal,
                boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), spreadRadius: 5, blurRadius: 10)],
              ),
              child: Text(wm.i18n.tapButton, style: TextStyle(fontSize: 28, color: Colors.white)),
            ),
          ),
          SizedBox(height: 40),
          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: wm.openLeaderboard,
                icon: Icon(Icons.leaderboard),
                label: Text(wm.i18n.leaderboardButton),
              ),
              SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: wm.openClaim,
                icon: Icon(Icons.monetization_on),
                label: Text(wm.i18n.startClaimButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
