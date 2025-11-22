class SettingsRepository {
  Future<Map<String, dynamic>> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'language': 'ru', 'notifications': true, 'theme': 'dark'};
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
