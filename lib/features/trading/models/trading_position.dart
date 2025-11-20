

class TradingPosition {
  final String id;
  final String ticker;
  final String name;
  final double quantity;
  final double entryPrice;
  final double currentPrice;
  final DateTime openedAt;
  final String? logoUrl;

  TradingPosition({
    required this.id,
    required this.ticker,
    required this.name,
    required this.quantity,
    required this.entryPrice,
    required this.currentPrice,
    required this.openedAt,
    this.logoUrl,
  });

  double get pnl => (currentPrice - entryPrice) * quantity;
  double get pnlPercent => entryPrice > 0 ? ((currentPrice - entryPrice) / entryPrice) * 100 : 0;
  bool get isProfit => pnl >= 0;
}

