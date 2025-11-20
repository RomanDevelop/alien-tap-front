
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'package:intl/intl.dart';
import 'portfolio_wm.dart';
import 'di/portfolio_wm_builder.dart';
import '../../../trading/models/trading_position.dart';
import '../../models/portfolio_history.dart';

class PortfolioPage extends CoreMwwmWidget<PortfolioWidgetModel> {
  PortfolioPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createPortfolioWidgetModel(ctx));

  @override
  WidgetState<PortfolioPage, PortfolioWidgetModel> createWidgetState() => _PortfolioPageState();
}

class _PortfolioPageState extends WidgetState<PortfolioPage, PortfolioWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: NeonTheme.backgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildTabBar(context),
              Expanded(
                child: StreamBuilder<int>(
                  stream: wm.selectedTabStream,
                  initialData: 0,
                  builder: (ctx, snap) {
                    final tab = snap.data ?? 0;
                    if (tab == 0) {
                      return _buildPositionsTab(context);
                    } else if (tab == 1) {
                      return _buildHistoryTab(context);
                    } else {
                      return _buildEarningsTab(context);
                    }
                  },
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
          icon: Icon(Icons.arrow_back, color: NeonTheme.brandBrightGreen),
          onPressed: wm.goBack,
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return StreamBuilder<int>(
      stream: wm.selectedTabStream,
      initialData: 0,
      builder: (ctx, snap) {
        final selectedIndex = snap.data ?? 0;
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeonTheme.darkCard.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  context,
                  wm.i18n.openPositions,
                  0,
                  selectedIndex == 0,
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  context,
                  wm.i18n.history,
                  1,
                  selectedIndex == 1,
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  context,
                  wm.i18n.totalEarned,
                  2,
                  selectedIndex == 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(BuildContext context, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => wm.selectTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [NeonTheme.brandBrightGreen, NeonTheme.brandMediumBlue],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? NeonTheme.darkBackground : NeonTheme.mediumText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPositionsTab(BuildContext context) {
    return StreamBuilder<List<TradingPosition>>(
      stream: wm.positionsStream,
      initialData: [],
      builder: (ctx, snap) {
        final positions = snap.data ?? [];
        if (positions.isEmpty) {
          return Center(
            child: Text(
              wm.i18n.noPositions,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: NeonTheme.mediumText,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: positions.length,
          itemBuilder: (ctx, index) => _buildPositionCard(context, positions[index]),
        );
      },
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
                      color: NeonTheme.brandBrightGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.currency_bitcoin,
                      color: NeonTheme.brandBrightGreen,
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
                      color: isProfit ? NeonTheme.brandBrightGreen : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${isProfit ? '+' : ''}${position.pnlPercent.toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isProfit ? NeonTheme.brandBrightGreen : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(context, 'Вход', '\$${position.entryPrice.toStringAsFixed(2)}'),
              _buildInfoColumn(context, 'Текущая', '\$${position.currentPrice.toStringAsFixed(2)}'),
              _buildInfoColumn(context, 'Кол-во', position.quantity.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: NeonTheme.mediumText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: NeonTheme.lightText,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    return StreamBuilder<List<PortfolioHistory>>(
      stream: wm.historyStream,
      initialData: [],
      builder: (ctx, snap) {
        final history = snap.data ?? [];
        if (history.isEmpty) {
          return Center(
            child: Text(
              wm.i18n.noHistory,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: NeonTheme.mediumText,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: history.length,
          itemBuilder: (ctx, index) => _buildHistoryCard(context, history[index]),
        );
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, PortfolioHistory history) {
    final isBuy = history.type == 'buy';
    final isProfit = history.profit != null && history.profit! > 0;
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: NeonTheme.cardGradient,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isBuy
                      ? NeonTheme.brandBrightGreen.withOpacity(0.2)
                      : NeonTheme.brandDarkBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isBuy ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isBuy ? NeonTheme.brandBrightGreen : NeonTheme.brandDarkBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${isBuy ? wm.i18n.buy : wm.i18n.sell} ${history.ticker}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: NeonTheme.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateFormat.format(history.date),
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
                '${history.amount.toStringAsFixed(2)} ALEN',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: NeonTheme.lightText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (history.profit != null)
                Text(
                  '${isProfit ? '+' : ''}${history.profit!.toStringAsFixed(2)} ALEN',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isProfit ? NeonTheme.brandBrightGreen : Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsTab(BuildContext context) {
    return StreamBuilder<Map<String, double>>(
      stream: wm.earningsStream,
      initialData: {'week': 0.0, 'month': 0.0, 'allTime': 0.0},
      builder: (ctx, snap) {
        final earnings = snap.data ?? {'week': 0.0, 'month': 0.0, 'allTime': 0.0};
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildEarningsCard(context, wm.i18n.week, earnings['week'] ?? 0.0),
              const SizedBox(height: 16),
              _buildEarningsCard(context, wm.i18n.month, earnings['month'] ?? 0.0),
              const SizedBox(height: 16),
              _buildEarningsCard(context, wm.i18n.allTime, earnings['allTime'] ?? 0.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEarningsCard(BuildContext context, String period, double amount) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NeonTheme.brandDarkBlue.withOpacity(0.2),
            NeonTheme.brandBrightGreen.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonTheme.brandBrightGreen.withOpacity(0.5), width: 2),
        boxShadow: NeonTheme.neonGlow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            period,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: NeonTheme.lightText,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} ALEN',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: NeonTheme.brandBrightGreen,
              shadows: NeonTheme.neonTextShadow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

