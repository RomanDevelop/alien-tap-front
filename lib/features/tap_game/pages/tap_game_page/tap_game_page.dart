import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'tap_game_wm.dart';
import 'di/tap_game_wm_builder.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';

class TapGamePage extends CoreMwwmWidget<TapGameWidgetModel> {
  final TapRepository repository;

  TapGamePage({required this.repository, Key? key})
    : super(key: key, widgetModelBuilder: (ctx) => createTapGameWidgetModel(ctx, repository: repository));

  @override
  WidgetState<TapGamePage, TapGameWidgetModel> createWidgetState() => _TapGamePageState();
}

class _TapGamePageState extends WidgetState<TapGamePage, TapGameWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: NeonTheme.backgroundGradient,
      child: SafeArea(
        child: Column(
          children: [
            _buildTopPanel(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      _buildTokenFund(context),
                      const SizedBox(height: 40),

                      _buildTapButton(context),
                      const SizedBox(height: 40),

                      _buildSessionCounter(context),
                      const SizedBox(height: 40),

                      _buildTransferButton(context),
                      const SizedBox(height: 40),
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

  Widget _buildTopPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [NeonTheme.darkSurface, NeonTheme.darkCard],
        ),
        boxShadow: [BoxShadow(color: NeonTheme.brandBrightGreen.withOpacity(0.2), blurRadius: 10, spreadRadius: 1)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: NeonTheme.brandBrightGreen,
            onPressed: () {
              final scaffoldState = Scaffold.maybeOf(context);
              scaffoldState?.openDrawer();
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wm.i18n.yourBalance,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: NeonTheme.mediumText),
                ),
                const SizedBox(height: 4),
                StreamBuilder<double>(
                  stream: wm.alenBalanceStream,
                  initialData: wm.alenBalance,
                  builder: (ctx, snap) {
                    final balance = snap.data ?? 0;
                    return Text(
                      '${balance.toStringAsFixed(0)} ALEN',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: NeonTheme.brandBrightGreen,
                        shadows: NeonTheme.neonTextShadow,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            children: [
              StreamBuilder<bool>(
                stream: wm.isSavingStream,
                initialData: false,
                builder: (ctx, snap) {
                  if (snap.data == true) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.brandBrightGreen),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              TextButton(
                onPressed: wm.openWithdraw,
                child: Text(
                  wm.i18n.withdrawButton,
                  style: TextStyle(color: NeonTheme.brandDarkBlue, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: Icon(Icons.person),
                tooltip: wm.i18n.profileButton,
                onPressed: wm.openProfile,
                color: NeonTheme.brandBrightGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenFund(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: wm.tokenFundStream,
      initialData: {'total': 900000000.0, 'usdValue': 241430.0},
      builder: (ctx, snap) {
        final fund = snap.data ?? {'total': 0.0, 'usdValue': 0.0};
        final total = fund['total'] as double;
        final usdValue = fund['usdValue'] as double;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeonTheme.darkCard.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeonTheme.brandBrightGreen.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wm.i18n.tokenFund,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: NeonTheme.mediumText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(total / 1000000).toStringAsFixed(0)}M ALEN = \$${(usdValue / 1000).toStringAsFixed(0)}K',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: NeonTheme.lightText, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.info_outline, size: 20),
                color: NeonTheme.brandBrightGreen,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          backgroundColor: NeonTheme.darkSurface,
                          title: Text(wm.i18n.tokenFund, style: TextStyle(color: NeonTheme.brandBrightGreen)),
                          content: Text(wm.i18n.tokenFundInfo, style: TextStyle(color: NeonTheme.lightText)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text('OK', style: TextStyle(color: NeonTheme.brandBrightGreen)),
                            ),
                          ],
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

  Widget _buildTapButton(BuildContext context) {
    return GestureDetector(
      onTap: wm.onTap,
      child: Container(
        height: 220,
        width: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [NeonTheme.brandBrightGreen, NeonTheme.brandLightGreen],
            stops: [0.0, 1.0],
          ),
          boxShadow: [
            ...NeonTheme.neonGlow,
            BoxShadow(color: NeonTheme.brandLightGreen.withOpacity(0.4), blurRadius: 40, spreadRadius: 8),
            BoxShadow(color: NeonTheme.brandBrightGreen.withOpacity(0.3), blurRadius: 60, spreadRadius: 12),
          ],
        ),
        child: Text(
          wm.i18n.tapButton,
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: NeonTheme.darkBackground,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCounter(BuildContext context) {
    return StreamBuilder<int>(
      stream: wm.sessionTappedStream,
      initialData: 0,
      builder: (ctx, snap) {
        final tapped = snap.data ?? 0;
        final duration = wm.sessionDuration;
        final minutes = duration.inMinutes;

        if (tapped == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [NeonTheme.brandDarkBlue.withOpacity(0.2), NeonTheme.brandBrightGreen.withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeonTheme.brandBrightGreen.withOpacity(0.5), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app, color: NeonTheme.brandBrightGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                '+$tapped ALEN ${wm.i18n.tappedInSession} $minutes ${wm.i18n.minutes}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: NeonTheme.brandBrightGreen, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransferButton(BuildContext context) {
    return StreamBuilder<int>(
      stream: wm.sessionTappedStream,
      initialData: 0,
      builder: (ctx, snap) {
        final tapped = snap.data ?? 0;

        if (tapped == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [NeonTheme.brandBrightGreen, NeonTheme.brandMediumBlue],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: NeonTheme.neonGlow,
          ),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (dialogCtx) => AlertDialog(
                      backgroundColor: NeonTheme.darkSurface,
                      title: Text(wm.i18n.confirmTransfer, style: TextStyle(color: NeonTheme.brandBrightGreen)),
                      content: Text(
                        '${wm.i18n.transferAmount} $tapped ALEN → ${wm.i18n.tradingButton}',
                        style: TextStyle(color: NeonTheme.lightText),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                          child: Text('Отмена', style: TextStyle(color: NeonTheme.mediumText)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogCtx).pop();
                            wm.transferToTrading();
                          },
                          child: Text(
                            wm.i18n.confirmTransfer,
                            style: TextStyle(color: NeonTheme.brandBrightGreen, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: NeonTheme.darkBackground,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              '${wm.i18n.transferAmount} $tapped ALEN → ${wm.i18n.tradingButton}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
        );
      },
    );
  }
}
