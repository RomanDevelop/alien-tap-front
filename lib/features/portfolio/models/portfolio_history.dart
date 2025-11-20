

class PortfolioHistory {
  final String id;
  final String type; 
  final String ticker;
  final String name;
  final double amount;
  final double? profit;
  final DateTime date;

  PortfolioHistory({
    required this.id,
    required this.type,
    required this.ticker,
    required this.name,
    required this.amount,
    this.profit,
    required this.date,
  });
}

