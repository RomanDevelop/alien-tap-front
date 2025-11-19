// lib/features/portfolio/repositories/portfolio_repository.dart
import '../models/portfolio_history.dart';
import '../../trading/models/trading_position.dart';

class PortfolioRepository {
  Future<List<TradingPosition>> getOpenPositions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      TradingPosition(
        id: '1',
        ticker: 'AAPL',
        name: 'Apple Inc.',
        quantity: 10.0,
        entryPrice: 200.0,
        currentPrice: 204.30,
        openedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TradingPosition(
        id: '2',
        ticker: 'BTC',
        name: 'Bitcoin',
        quantity: 0.5,
        entryPrice: 42000.0,
        currentPrice: 43250.00,
        openedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  Future<List<PortfolioHistory>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      PortfolioHistory(
        id: '1',
        type: 'sell',
        ticker: 'TSLA',
        name: 'Tesla Inc.',
        amount: 500.0,
        profit: 73.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      PortfolioHistory(
        id: '2',
        type: 'buy',
        ticker: 'AAPL',
        name: 'Apple Inc.',
        amount: 2000.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PortfolioHistory(
        id: '3',
        type: 'sell',
        ticker: 'ETH',
        name: 'Ethereum',
        amount: 1000.0,
        profit: -50.0,
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  Future<Map<String, double>> getEarnings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'week': 150.0,
      'month': 450.0,
      'allTime': 1250.0,
    };
  }
}

