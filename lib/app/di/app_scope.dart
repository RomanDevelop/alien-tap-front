import 'package:get_it/get_it.dart';
import '../../data/api/game_api.dart';
import '../../features/tap_game/repositories/tap_repository.dart';

final locator = GetIt.instance;

Future<void> setupAppScope({required String apiBaseUrl}) async {
  locator.registerLazySingleton<GameApi>(() => GameApi(apiBaseUrl));

  locator.registerLazySingleton<TapRepository>(() => TapRepository(api: locator<GameApi>()));

  final gameApi = locator<GameApi>();
  try {
    await gameApi.initialize();
  } catch (e) {}
}
