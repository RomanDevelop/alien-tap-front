// lib/features/liquidity/pages/liquidity_page/liquidity_page.dart
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'liquidity_wm.dart';
import 'di/liquidity_wm_builder.dart';

class LiquidityPage extends CoreMwwmWidget<LiquidityWidgetModel> {
  LiquidityPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createLiquidityWidgetModel(ctx));

  @override
  WidgetState<LiquidityPage, LiquidityWidgetModel> createWidgetState() => _LiquidityPageState();
}

class _LiquidityPageState extends WidgetState<LiquidityPage, LiquidityWidgetModel> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
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
                        _buildDescription(context),
                        const SizedBox(height: 24),
                        _buildPoolStats(context),
                        const SizedBox(height: 32),
                        _buildAddLiquidityPanel(context),
                        const SizedBox(height: 32),
                        _buildRemoveLiquidityPanel(context),
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

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonTheme.darkCard.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonTheme.neonCyan.withOpacity(0.3), width: 1),
      ),
      child: Text(
        wm.i18n.description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: NeonTheme.lightText,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPoolStats(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: wm.poolInfoStream,
      initialData: {},
      builder: (ctx, snap) {
        final info = snap.data ?? {};
        final lpBalance = info['lpBalance'] as double? ?? 0.0;
        final rewards24h = info['rewards24h'] as double? ?? 0.0;
        final totalTvl = info['totalTvl'] as double? ?? 0.0;
        final apr = info['apr'] as double? ?? 0.0;

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
            children: [
              _buildStatRow(context, wm.i18n.yourLpBalance, '${lpBalance.toStringAsFixed(2)} LP'),
              const SizedBox(height: 16),
              _buildStatRow(context, wm.i18n.rewards24h, '${rewards24h.toStringAsFixed(2)} ALEN'),
              const SizedBox(height: 16),
              _buildStatRow(context, wm.i18n.totalTvl, '\$${(totalTvl / 1000).toStringAsFixed(0)}K'),
              const SizedBox(height: 16),
              _buildStatRow(context, wm.i18n.apr, '${apr.toStringAsFixed(2)}%', isHighlight: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: NeonTheme.mediumText,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isHighlight ? NeonTheme.neonCyan : NeonTheme.lightText,
            fontWeight: FontWeight.bold,
            shadows: isHighlight ? NeonTheme.neonTextShadow : null,
          ),
        ),
      ],
    );
  }

  Widget _buildAddLiquidityPanel(BuildContext context) {
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
            wm.i18n.addLiquidity,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: NeonTheme.lightText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            wm.i18n.investAmount,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: NeonTheme.lightText,
            ),
          ),
          const SizedBox(height: 12),
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
                      style: TextStyle(color: NeonTheme.lightText, fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
              _buildAmountButton('+10', () => wm.addToInvestAmount(10)),
              const SizedBox(width: 8),
              _buildAmountButton('+100', () => wm.addToInvestAmount(100)),
              const SizedBox(width: 8),
              _buildAmountButton('MAX', () => wm.setMaxInvestAmount()),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<double>(
            stream: wm.investAmountStream,
            initialData: 100.0,
            builder: (ctx, amountSnap) {
              final amount = amountSnap.data ?? 100.0;
              final pollNeeded = wm.calculatePollNeeded(amount);
              final share = wm.calculateShare(amount);
              return Column(
                children: [
                  _buildInfoRow(context, wm.i18n.pollNeeded, '${pollNeeded.toStringAsFixed(2)} POLL'),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, wm.i18n.estimatedShare, '${share.toStringAsFixed(4)}%'),
                ],
              );
            },
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
                  onPressed: isLoading ? null : wm.addLiquidity,
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
                          wm.i18n.addToPool,
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
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
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

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: NeonTheme.mediumText,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: NeonTheme.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveLiquidityPanel(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: wm.poolInfoStream,
      initialData: {},
      builder: (ctx, snap) {
        final info = snap.data ?? {};
        final lpTokens = info['lpTokens'] as double? ?? 0.0;
        final profit = info['accumulatedProfit'] as double? ?? 0.0;

        if (lpTokens == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: NeonTheme.darkCard.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeonTheme.neonPurple.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                wm.i18n.removeLiquidity,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: NeonTheme.lightText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(context, wm.i18n.yourLpTokens, '${lpTokens.toStringAsFixed(2)} LP'),
              const SizedBox(height: 8),
              _buildInfoRow(context, wm.i18n.accumulatedProfit, '${profit.toStringAsFixed(2)} ALEN'),
              const SizedBox(height: 20),
              StreamBuilder<bool>(
                stream: wm.isLoadingStream,
                initialData: false,
                builder: (ctx, loadingSnap) {
                  final isLoading = loadingSnap.data ?? false;
                  return Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [NeonTheme.neonPurple, NeonTheme.neonPink],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: NeonTheme.neonPurpleGlow,
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : wm.removeLiquidity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
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
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              wm.i18n.withdraw,
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
}

