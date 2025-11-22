import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'wallet_wm.dart';
import 'di/wallet_wm_builder.dart';

class WalletPage extends CoreMwwmWidget<WalletWidgetModel> {
  WalletPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createWalletWidgetModel(ctx));

  @override
  WidgetState<WalletPage, WalletWidgetModel> createWidgetState() => _WalletPageState();
}

class _WalletPageState extends WidgetState<WalletPage, WalletWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    children: [
                      _buildBalanceCard(context),
                      const SizedBox(height: 24),
                      _buildActions(context),
                      const SizedBox(height: 32),
                      _buildHistory(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
        leading: IconButton(icon: Icon(Icons.arrow_back, color: NeonTheme.brandBrightGreen), onPressed: wm.goBack),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: wm.balanceStream,
      initialData: {'total': 0.0, 'available': 0.0, 'locked': 0.0},
      builder: (ctx, snap) {
        final balance = snap.data ?? {};
        final total = balance['total'] as double? ?? 0.0;
        final available = balance['available'] as double? ?? 0.0;
        final locked = balance['locked'] as double? ?? 0.0;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [NeonTheme.brandDarkBlue.withOpacity(0.3), NeonTheme.brandBrightGreen.withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeonTheme.brandBrightGreen.withOpacity(0.5), width: 2),
            boxShadow: NeonTheme.neonGlow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wm.i18n.totalBalance,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: NeonTheme.mediumText),
              ),
              const SizedBox(height: 8),
              Text(
                '${total.toStringAsFixed(2)} ALEN',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: NeonTheme.brandBrightGreen,
                  shadows: NeonTheme.neonTextShadow,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wm.i18n.availableBalance,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: NeonTheme.mediumText),
                      ),
                      Text(
                        '${available.toStringAsFixed(2)} ALEN',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: NeonTheme.lightText),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        wm.i18n.lockedBalance,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: NeonTheme.mediumText),
                      ),
                      Text(
                        '${locked.toStringAsFixed(2)} ALEN',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: NeonTheme.mediumText),
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

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            decoration: NeonTheme.buttonGradient,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: NeonTheme.darkBackground,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(wm.i18n.deposit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 56,
            decoration: NeonTheme.secondaryButtonGradient,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: NeonTheme.lightText,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(wm.i18n.withdraw, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          wm.i18n.history,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: NeonTheme.lightText, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: wm.transactionsStream,
          initialData: [],
          builder: (ctx, snap) {
            final transactions = snap.data ?? [];
            if (transactions.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: NeonTheme.darkCard.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    wm.i18n.noTransactions,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: NeonTheme.mediumText),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
