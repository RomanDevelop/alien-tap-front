

class LiquidityRepository {
  Future<Map<String, dynamic>> getPoolInfo() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'lpBalance': 5000.0,
      'rewards24h': 12.5,
      'totalTvl': 250000.0,
      'apr': 18.5,
      'lpTokens': 5000.0,
      'accumulatedProfit': 125.0,
    };
  }

  Future<void> addLiquidity(double alenAmount) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> removeLiquidity(double lpTokens) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

