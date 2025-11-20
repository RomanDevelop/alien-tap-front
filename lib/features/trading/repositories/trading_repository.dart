
import '../models/asset.dart';
import '../models/trading_position.dart';

class TradingRepository {
  
  Future<Asset?> searchAsset(String ticker) async {
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    
    final mockAssets = {
      'AAPL': Asset(
        ticker: 'AAPL',
        name: 'Apple Inc.',
        price: 204.30,
        change24h: 3.74,
        changePercent24h: 1.83,
        sparkline: [200.0, 201.5, 202.0, 203.5, 204.3],
      ),
      'TSLA': Asset(
        ticker: 'TSLA',
        name: 'Tesla Inc.',
        price: 245.50,
        change24h: -5.20,
        changePercent24h: -2.07,
        sparkline: [250.0, 248.0, 246.0, 245.5, 245.5],
      ),
      'BTC': Asset(
        ticker: 'BTC',
        name: 'Bitcoin',
        price: 43250.00,
        change24h: 1250.00,
        changePercent24h: 2.98,
        sparkline: [42000.0, 42500.0, 43000.0, 43200.0, 43250.0],
      ),
      'ETH': Asset(
        ticker: 'ETH',
        name: 'Ethereum',
        price: 2650.00,
        change24h: 45.50,
        changePercent24h: 1.75,
        sparkline: [2600.0, 2620.0, 2630.0, 2640.0, 2650.0],
      ),
    };
    
    return mockAssets[ticker.toUpperCase()];
  }

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

  Future<void> buyAsset(String ticker, double amount) async {
    
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> closePosition(String positionId) async {
    
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

