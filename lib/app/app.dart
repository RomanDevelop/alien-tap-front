// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:alien_tap/app/router/app_router.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';

class AlienTapApp extends StatelessWidget {
  const AlienTapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Alien Tap',
      theme: NeonTheme.theme,
      routerConfig: AppRouter.createRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
