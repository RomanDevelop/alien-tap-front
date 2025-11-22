class WalletRepository {
  Future<Map<String, dynamic>> getWalletBalance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'total': 1000.0, 'available': 800.0, 'locked': 200.0};
  }

  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}
