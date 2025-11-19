// lib/features/trading/models/asset.dart

class Asset {
  final String ticker;
  final String name;
  final double price;
  final double change24h;
  final double changePercent24h;
  final String? logoUrl;
  final List<double>? sparkline; // Мини-график

  Asset({
    required this.ticker,
    required this.name,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    this.logoUrl,
    this.sparkline,
  });
}

