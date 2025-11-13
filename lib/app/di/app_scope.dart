// lib/app/di/app_scope.dart
import 'package:get_it/get_it.dart';
import '../../data/api/game_api.dart';
import '../../features/tap_game/repositories/tap_repository.dart';

final locator = GetIt.instance;

Future<void> setupAppScope({required String apiBaseUrl}) async {
  // Register GameApi as singleton
  locator.registerLazySingleton<GameApi>(() => GameApi(apiBaseUrl));

  // Register TapRepository as singleton
  locator.registerLazySingleton<TapRepository>(() => TapRepository(api: locator<GameApi>()));

  // Initialize GameApi (sets up storage only, auth will happen on first API call)
  final gameApi = locator<GameApi>();
  try {
    await gameApi.initialize();
  } catch (e) {
    // Don't fail initialization if auth fails (e.g., in dev mode without Telegram)
    // Authentication will be retried when making API calls
    print('Warning: GameApi initialization failed: $e');
  }
}
