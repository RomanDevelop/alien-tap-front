// lib/app/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alien_tap/features/auth/pages/auth_page/auth_page.dart';
import 'package:alien_tap/features/tap_game/pages/tap_game_page/tap_game_page.dart';
import 'package:alien_tap/features/leaderboard/pages/leaderboard_page/leaderboard_page.dart';
import 'package:alien_tap/features/claim/pages/claim_page/claim_page.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/app/di/app_scope.dart';
import 'package:alien_tap/data/api/game_api.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/auth',
      redirect: (context, state) {
        // Проверяем наличие токена
        final isAuthenticated = _checkAuth();
        final isAuthRoute = state.matchedLocation == '/auth';
        final targetRoute = state.matchedLocation;

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
      },
      routes: [
        GoRoute(path: '/auth', builder: (context, state) => AuthPage()),
        GoRoute(
          path: '/game',
          builder: (context, state) {
            final repository = locator<TapRepository>();
            return TapGamePage(repository: repository);
          },
        ),
        GoRoute(path: '/leaderboard', builder: (context, state) => LeaderboardPage()),
        GoRoute(path: '/claim', builder: (context, state) => ClaimPage()),
      ],
    );
  }

  static bool _checkAuth() {
    try {
      final api = locator<GameApi>();
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
      return false;
    }
  }
}
