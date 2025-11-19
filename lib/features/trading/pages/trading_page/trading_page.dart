// lib/features/trading/pages/trading_page/trading_page.dart
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'trading_wm.dart';
import 'di/trading_wm_builder.dart';
import '../../models/asset.dart';
import '../../models/trading_position.dart';

class TradingPage extends CoreMwwmWidget<TradingWidgetModel> {
  TradingPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createTradingWidgetModel(ctx));

  @override
  WidgetState<TradingPage, TradingWidgetModel> createWidgetState() => _TradingPageState();
}

class _TradingPageState extends WidgetState<TradingPage, TradingWidgetModel> {
  final _tickerController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _tickerController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: NeonTheme.backgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBalanceCard(context),
                        const SizedBox(height: 24),
                        _buildSearchField(context),
                        const SizedBox(height: 24),
                        _buildAssetCard(context),
                        const SizedBox(height: 24),
                        _buildBuyPanel(context),
                        const SizedBox(height: 32),
                        _buildPositionsSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [NeonTheme.darkSurface, NeonTheme.darkCard],
        ),
      ),
      child: AppBar(
        title: Text(
          wm.i18n.pageTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(shadows: NeonTheme.neonTextShadow),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: NeonTheme.neonCyan),
          onPressed: wm.goBack,
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return StreamBuilder<double>(
      stream: wm.tradingBalanceStream,
      initialData: wm.tradingBalance,
      builder: (ctx, snap) {
        final balance = snap.data ?? 0;
        final usdValue = balance * 0.00245; // Мок курс 1 ALEN = $0.00245
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                NeonTheme.neonPurple.withOpacity(0.2),
                NeonTheme.neonCyan.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeonTheme.neonCyan.withOpacity(0.5), width: 2),
            boxShadow: NeonTheme.neonGlow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wm.i18n.tradingBalance,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NeonTheme.mediumText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${balance.toStringAsFixed(2)} ALEN',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: NeonTheme.neonCyan,
                  shadows: NeonTheme.neonTextShadow,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${wm.i18n.equivalent}: \$${usdValue.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NeonTheme.mediumText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _tickerController,
      style: TextStyle(color: NeonTheme.lightText),
      decoration: InputDecoration(
        labelText: wm.i18n.enterTicker,
        hintText: wm.i18n.tickerHint,
        prefixIcon: Icon(Icons.search, color: NeonTheme.neonCyan),
        suffixIcon: StreamBuilder<bool>(
          stream: wm.isLoadingStream,
          initialData: false,
          builder: (ctx, snap) {
            if (snap.data == true) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.neonCyan),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          wm.searchAsset(value);
        } else {
          wm.searchAsset('');
        }
      },
    );
  }

  Widget _buildAssetCard(BuildContext context) {
    return StreamBuilder<Asset?>(
      stream: wm.selectedAssetStream,
      initialData: null,
      builder: (ctx, snap) {
        final asset = snap.data;
        if (asset == null) {
          return const SizedBox.shrink();
        }

        final isPositive = asset.changePercent24h >= 0;
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: NeonTheme.cardGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: NeonTheme.neonCyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.currency_bitcoin,
                      color: NeonTheme.neonCyan,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: NeonTheme.lightText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          asset.ticker,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: NeonTheme.mediumText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wm.i18n.currentPrice,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NeonTheme.mediumText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${asset.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: NeonTheme.lightText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        wm.i18n.change,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NeonTheme.mediumText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${isPositive ? '+' : ''}${asset.changePercent24h.toStringAsFixed(2)}%',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isPositive ? NeonTheme.neonGreen : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBuyPanel(BuildContext context) {
    return StreamBuilder<Asset?>(
      stream: wm.selectedAssetStream,
      initialData: null,
      builder: (ctx, snap) {
        final asset = snap.data;
        if (asset == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: NeonTheme.darkCard.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeonTheme.neonCyan.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                wm.i18n.investAmount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: NeonTheme.lightText,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<double>(
                      stream: wm.investAmountStream,
                      initialData: 100.0,
                      builder: (ctx, amountSnap) {
                        final amount = amountSnap.data ?? 100.0;
                        return TextField(
                          controller: _amountController..text = amount.toStringAsFixed(0),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: NeonTheme.lightText, fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (value) {
                            final num = double.tryParse(value);
                            if (num != null) {
                              wm.setInvestAmount(num);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildAmountButton(wm.i18n.add10, () => wm.addToInvestAmount(10)),
                  const SizedBox(width: 8),
                  _buildAmountButton(wm.i18n.add100, () => wm.addToInvestAmount(100)),
                  const SizedBox(width: 8),
                  _buildAmountButton(wm.i18n.max, () => wm.setMaxInvestAmount()),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<bool>(
                stream: wm.isLoadingStream,
                initialData: false,
                builder: (ctx, loadingSnap) {
                  final isLoading = loadingSnap.data ?? false;
                  return Container(
                    height: 56,
                    decoration: isLoading ? null : NeonTheme.buttonGradient,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : wm.buyAsset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoading ? NeonTheme.darkCard : Colors.transparent,
                        foregroundColor: isLoading ? NeonTheme.neonCyan : NeonTheme.darkBackground,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.neonCyan),
                              ),
                            )
                          : Text(
                              wm.i18n.buyButton,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmountButton(String label, VoidCallback onPressed) {
    return Container(
      width: 60,
      height: 48,
      decoration: BoxDecoration(
        color: NeonTheme.neonCyan.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NeonTheme.neonCyan.withOpacity(0.5), width: 1),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: NeonTheme.neonCyan,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPositionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          wm.i18n.openPositions,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: NeonTheme.lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<TradingPosition>>(
          stream: wm.positionsStream,
          initialData: [],
          builder: (ctx, snap) {
            final positions = snap.data ?? [];
            if (positions.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: NeonTheme.darkCard.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    wm.i18n.noPositions,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: NeonTheme.mediumText,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: positions.map((position) => _buildPositionCard(context, position)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPositionCard(BuildContext context, TradingPosition position) {
    final isProfit = position.isProfit;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: NeonTheme.cardGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: NeonTheme.neonCyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.currency_bitcoin,
                      color: NeonTheme.neonCyan,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: NeonTheme.lightText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        position.ticker,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NeonTheme.mediumText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isProfit ? '+' : ''}${position.pnl.toStringAsFixed(2)} ALEN',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isProfit ? NeonTheme.neonGreen : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${isProfit ? '+' : ''}${position.pnlPercent.toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isProfit ? NeonTheme.neonGreen : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wm.i18n.entryPrice,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NeonTheme.mediumText,
                    ),
                  ),
                  Text(
                    '\$${position.entryPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeonTheme.lightText,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wm.i18n.currentPriceLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NeonTheme.mediumText,
                    ),
                  ),
                  Text(
                    '\$${position.currentPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeonTheme.lightText,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wm.i18n.quantity,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NeonTheme.mediumText,
                    ),
                  ),
                  Text(
                    position.quantity.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeonTheme.lightText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isProfit
                    ? [NeonTheme.neonGreen.withOpacity(0.2), NeonTheme.neonCyan.withOpacity(0.2)]
                    : [Colors.red.withOpacity(0.2), Colors.red.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isProfit ? NeonTheme.neonGreen.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: TextButton(
              onPressed: () => wm.closePosition(position.id),
              child: Text(
                wm.i18n.closePosition,
                style: TextStyle(
                  color: isProfit ? NeonTheme.neonGreen : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

