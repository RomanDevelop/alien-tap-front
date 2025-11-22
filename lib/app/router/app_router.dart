import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alien_tap/features/auth/pages/auth_page/auth_page.dart';
import 'package:alien_tap/features/tap_game/pages/tap_game_page/tap_game_page.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/leaderboard_page.dart';
import 'package:alien_tap/features/claim/pages/claim_page/claim_page.dart';
import 'package:alien_tap/features/trading/pages/trading_page/trading_page.dart';
import 'package:alien_tap/features/portfolio/pages/portfolio_page/portfolio_page.dart';
import 'package:alien_tap/features/liquidity/pages/liquidity_page/liquidity_page.dart';
import 'package:alien_tap/features/profile/pages/profile_page/profile_page.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/app/di/app_scope.dart';
import 'package:alien_tap/app/navigation/main_navigation.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/auth',
      errorBuilder:
          (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Ошибка навигации: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => context.go('/auth'), child: const Text('На главную')),
                ],
              ),
            ),
          ),
      redirect: (context, state) {
        try {
          final matchedLocation = state.matchedLocation;
          final validRoutes = const {
            '/auth',
            '/game',
            '/leaderboard',
            '/claim',
            '/trading',
            '/portfolio',
            '/liquidity',
            '/profile',
          };

          final isValidRoute =
              matchedLocation.startsWith('/') &&
              !matchedLocation.contains('tgWebAppData') &&
              !matchedLocation.contains('query_id') &&
              !matchedLocation.contains('auth_date') &&
              !matchedLocation.contains('hash=') &&
              !matchedLocation.contains('signature=') &&
              !matchedLocation.contains('&tgWebApp') &&
              validRoutes.contains(matchedLocation);

          if (!isValidRoute) {
            return _checkAuth() ? '/game' : '/auth';
          }

          final isAuthenticated = _checkAuth();
          final isAuthRoute = matchedLocation == '/auth';

          if (!isAuthenticated && !isAuthRoute) {
            return '/auth';
          }

          if (isAuthenticated && isAuthRoute) {
            return '/game';
          }

          return null;
        } catch (e) {
          return '/auth';
        }
      },
      routes: [
        GoRoute(path: '/auth', builder: (context, state) => AuthPage()),
        GoRoute(
          path: '/game',
          builder: (context, state) {
            try {
              final repository = locator<TapRepository>();
              final gamePage = TapGamePage(repository: repository);
              return MainNavigation(key: const ValueKey('game'), currentPath: '/game', child: gamePage);
            } catch (e) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ошибка загрузки игры: $e'),
                      ElevatedButton(onPressed: () => context.go('/auth'), child: const Text('Назад')),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        GoRoute(
          path: '/leaderboard',
          builder:
              (context, state) => MainNavigation(
                key: const ValueKey('leaderboard'),
                currentPath: '/leaderboard',
                child: LeaderboardPage(),
              ),
        ),
        GoRoute(
          path: '/claim',
          builder:
              (context, state) =>
                  MainNavigation(key: const ValueKey('claim'), currentPath: '/claim', child: ClaimPage()),
        ),
        GoRoute(
          path: '/trading',
          builder:
              (context, state) =>
                  MainNavigation(key: const ValueKey('trading'), currentPath: '/trading', child: TradingPage()),
        ),
        GoRoute(
          path: '/portfolio',
          builder:
              (context, state) =>
                  MainNavigation(key: const ValueKey('portfolio'), currentPath: '/portfolio', child: PortfolioPage()),
        ),
        GoRoute(
          path: '/liquidity',
          builder:
              (context, state) =>
                  MainNavigation(key: const ValueKey('liquidity'), currentPath: '/liquidity', child: LiquidityPage()),
        ),
        GoRoute(
          path: '/profile',
          builder:
              (context, state) =>
                  MainNavigation(key: const ValueKey('profile'), currentPath: '/profile', child: ProfilePage()),
        ),
      ],
    );
  }

  static bool? _cachedAuthState;
  static DateTime? _authCacheTime;
  static const _authCacheDuration = Duration(seconds: 1);

  static bool _checkAuth() {
    try {
      final now = DateTime.now();
      if (_cachedAuthState != null && _authCacheTime != null && now.difference(_authCacheTime!) < _authCacheDuration) {
        return _cachedAuthState!;
      }

      final storage = GetStorage();
      final token = storage.read<String>('jwt_token');
      final isAuth = token != null && token.isNotEmpty;

      _cachedAuthState = isAuth;
      _authCacheTime = now;
      return isAuth;
    } catch (e) {
      _cachedAuthState = false;
      _authCacheTime = DateTime.now();
      return false;
    }
  }

  static void invalidateAuthCache() {
    _cachedAuthState = null;
    _authCacheTime = null;
  }
}
