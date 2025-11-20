import 'package:get_storage/get_storage.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> getUserProfile() async {
    return {'userId': '123456789', 'username': 'User', 'alenBalance': 12450.0, 'avatarUrl': null};
  }

  Future<List<Map<String, dynamic>>> getOperationsHistory() async {
    return [
      {'id': '1', 'type': 'withdraw', 'amount': 100.0, 'date': DateTime.now().subtract(const Duration(days: 1))},
      {'id': '2', 'type': 'transfer', 'amount': 500.0, 'date': DateTime.now().subtract(const Duration(days: 3))},
      {'id': '3', 'type': 'claim', 'amount': 50.0, 'date': DateTime.now().subtract(const Duration(days: 5))},
    ];
  }

  Future<String> generateReferralLink() async {
    return 'https://t.me/alien_tap_bot?start=ref_123456789';
  }

  Future<void> logout() async {
    final storage = GetStorage();
    storage.remove('jwt_token');
    storage.remove('user_id');
  }
}
