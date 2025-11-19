// lib/app/router/app_router.dart
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
import 'package:alien_tap/data/api/game_api.dart';

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
          // Игнорируем hash параметры (tgWebAppData и т.д.) - они не являются маршрутами
          final matchedLocation = state.matchedLocation;
          
          // Проверяем, является ли matchedLocation валидным маршрутом
          // Валидные маршруты начинаются с '/' и не содержат hash параметры
          final isValidRoute = matchedLocation.startsWith('/') && 
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
          
          // Если это не валидный маршрут (hash параметры или неизвестный путь)
          if (!isValidRoute) {
            print('⚠️ Router: invalid route detected, redirecting. matchedLocation: $matchedLocation');
            // Проверяем авторизацию и редиректим на правильный маршрут
            final isAuthenticated = _checkAuth();
            if (isAuthenticated) {
              print('🔄 Redirecting to /game (authenticated, invalid route)');
              return '/game';
            } else {
              print('🔄 Redirecting to /auth (not authenticated, invalid route)');
              return '/auth';
            }
          }
          
          // Проверяем наличие токена
          final isAuthenticated = _checkAuth();
          final isAuthRoute = matchedLocation == '/auth';
          final targetRoute = matchedLocation;

          print('🔍 Router redirect: target=$targetRoute, isAuth=$isAuthenticated, isAuthRoute=$isAuthRoute');

          // Если не авторизован и не на экране авторизации → редирект на /auth
          if (!isAuthenticated && !isAuthRoute) {
            print('🔄 Redirecting to /auth (not authenticated)');
            return '/auth';
          }

          // Если авторизован и на экране авторизации → редирект на /game
          if (isAuthenticated && isAuthRoute) {
            print('🔄 Redirecting to /game (authenticated on auth page)');
            return '/game';
          }

          print('✅ Router: allowing access to $targetRoute');
          return null; // Разрешить доступ
        } catch (e) {
          print('❌ Router redirect error: $e');
          // В случае ошибки всегда редиректим на /auth
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
              print('❌ Error building AuthPage: $e');
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/game',
          builder: (context, state) {
            try {
              final repository = locator<TapRepository>();
              return TapGamePage(repository: repository);
            } catch (e) {
              print('❌ Error building TapGamePage: $e');
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
              return LeaderboardPage();
            } catch (e) {
              print('❌ Error building LeaderboardPage: $e');
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/claim',
          builder: (context, state) {
            try {
              return ClaimPage();
            } catch (e) {
              print('❌ Error building ClaimPage: $e');
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/trading',
          builder: (context, state) {
            try {
              return TradingPage();
            } catch (e) {
              print('❌ Error building TradingPage: $e');
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/portfolio',
          builder: (context, state) {
            try {
              return PortfolioPage();
            } catch (e) {
              print('❌ Error building PortfolioPage: $e');
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/liquidity',
          builder: (context, state) {
            try {
              return LiquidityPage();
            } catch (e) {
              print('❌ Error building LiquidityPage: $e');
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            try {
              return ProfilePage();
            } catch (e) {
              print('❌ Error building ProfilePage: $e');
              return Scaffold(body: Center(child: Text('Ошибка загрузки: $e')));
            }
          },
        ),
      ],
    );
  }

  static bool _checkAuth() {
    try {
      // Проверяем, инициализирован ли locator
      if (!locator.isRegistered<GameApi>()) {
        print('⚠️ Router _checkAuth(): GameApi not registered yet');
        return false;
      }

      // Use GetStorage directly to check token (more reliable)
      final storage = GetStorage();
      final token = storage.read<String>('jwt_token');
      final isAuth = token != null && token.isNotEmpty;
      // Debug logging
      print(
        '🔍 Router _checkAuth(): token=${token != null ? "exists (${token.length} chars)" : "null"}, isAuth=$isAuth',
      );
      return isAuth;
    } catch (e) {
      print('❌ Router _checkAuth() error: $e');
      // В случае ошибки считаем, что не авторизован
      return false;
    }
  }
}
