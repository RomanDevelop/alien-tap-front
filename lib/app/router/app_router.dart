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

          final isValidRoute =
              matchedLocation.startsWith('/') &&
              !matchedLocation.contains('tgWebAppData') &&
              !matchedLocation.contains('query_id') &&
              !matchedLocation.contains('auth_date') &&
              !matchedLocation.contains('hash=') &&
              !matchedLocation.contains('signature=') &&
              !matchedLocation.contains('&tgWebApp') &&
              (matchedLocation == '/auth' ||
                  matchedLocation == '/game' ||
                  matchedLocation == '/leaderboard' ||
                  matchedLocation == '/claim' ||
                  matchedLocation == '/trading' ||
                  matchedLocation == '/portfolio' ||
                  matchedLocation == '/liquidity' ||
                  matchedLocation == '/profile');

          if (!isValidRoute) {
            final isAuthenticated = _checkAuth();
            if (isAuthenticated) {
              return '/game';
            } else {
              return '/auth';
            }
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
        GoRoute(
          path: '/auth',
          builder: (context, state) {
            try {
              return AuthPage();
            } catch (e) {
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/game',
          builder: (context, state) {
            try {
              final repository = locator<TapRepository>();
              final gamePage = TapGamePage(repository: repository);
              return MainNavigation(currentPath: '/game', child: gamePage);
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
          builder: (context, state) {
            try {
              return MainNavigation(currentPath: '/leaderboard', child: LeaderboardPage());
            } catch (e) {
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/claim',
          builder: (context, state) {
            try {
              return MainNavigation(currentPath: '/claim', child: ClaimPage());
            } catch (e) {
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/trading',
          builder: (context, state) {
            try {
              return MainNavigation(currentPath: '/trading', child: TradingPage());
            } catch (e) {
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/portfolio',
          builder: (context, state) {
            try {
              return MainNavigation(currentPath: '/portfolio', child: PortfolioPage());
            } catch (e) {
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/liquidity',
          builder: (context, state) {
            try {
              return MainNavigation(currentPath: '/liquidity', child: LiquidityPage());
            } catch (e) {
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            try {
              return MainNavigation(currentPath: '/profile', child: ProfilePage());
            } catch (e) {
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
      ],
    );
  }

  static bool _checkAuth() {
    try {
      final storage = GetStorage();
      final token = storage.read<String>('jwt_token');
      final isAuth = token != null && token.isNotEmpty;
      return isAuth;
    } catch (e) {
      return false;
    }
  }
}
