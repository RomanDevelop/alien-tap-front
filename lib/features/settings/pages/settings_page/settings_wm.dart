import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'settings_i18n.dart';
import 'navigation/settings_navigator.dart';
import '../../repositories/settings_repository.dart';

class SettingsWidgetModel extends WidgetModel {
  final SettingsRepository _repository;
  final SettingsNavigator _navigator;
  final SettingsI18n i18n;
  final Logger _logger = Logger();
  final BehaviorSubject<Map<String, dynamic>> _settings = BehaviorSubject.seeded({});
  Stream<Map<String, dynamic>> get settingsStream => _settings.stream;
  SettingsWidgetModel(this._repository, this._navigator, this.i18n, WidgetModelDependencies dependencies)
    : super(dependencies);
  @override
  void onLoad() {
    super.onLoad();
    _loadSettings();
  }

  @override
  void dispose() {
    _settings.close();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _repository.getSettings();
      _settings.add(settings);
    } catch (e) {
      _logger.e('Failed to load settings', error: e);
    }
  }

  void goBack() => _navigator.goBack();
}
