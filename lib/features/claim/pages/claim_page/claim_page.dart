
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/features/claim/pages/claim_page/di/claim_wm_builder.dart';
import 'package:alien_tap/features/claim/pages/claim_page/claim_state.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'claim_wm.dart';

class ClaimPage extends CoreMwwmWidget<ClaimWidgetModel> {
  ClaimPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createClaimWidgetModel(ctx));

  @override
  WidgetState<ClaimPage, ClaimWidgetModel> createWidgetState() => _ClaimPageState();
}

class _ClaimPageState extends WidgetState<ClaimPage, ClaimWidgetModel> {
  final _amountController = TextEditingController();
  final _walletController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: NeonTheme.backgroundGradient,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    NeonTheme.darkSurface,
                    NeonTheme.darkCard,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: NeonTheme.brandLightGreen.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: AppBar(
                title: Text(
                  wm.i18n.pageTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    shadows: NeonTheme.neonTextShadow,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
            Expanded(
              child: StreamBuilder<ClaimState>(
                stream: wm.stateStream,
                initialData: ClaimState.input,
                builder: (ctx, snap) {
                  final state = snap.data ?? ClaimState.input;

                  if (state == ClaimState.confirmation) {
                    return _buildConfirmationView();
                  }

                  if (state == ClaimState.success) {
                    return _buildSuccessView();
                  }

                  return _buildInputView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              wm.i18n.enterAmount,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            StreamBuilder<int>(
              stream: wm.currentScoreStream,
              initialData: 0,
              builder: (ctx, snap) {
                final score = snap.data ?? 0;
                return Container(
                  padding: const EdgeInsets.all(20),
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
                    border: Border.all(
                      color: NeonTheme.brandBrightGreen.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '${wm.i18n.availableScore}: $score',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      shadows: NeonTheme.neonTextShadow,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: NeonTheme.lightText),
              decoration: InputDecoration(
                labelText: wm.i18n.amountLabel,
                hintText: wm.i18n.amountHint,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _walletController,
              style: TextStyle(color: NeonTheme.lightText, fontFamily: 'monospace'),
              decoration: InputDecoration(
                labelText: wm.i18n.walletAddress,
                hintText: wm.i18n.walletAddressHint,
                prefixIcon: Icon(Icons.account_balance_wallet, color: NeonTheme.brandBrightGreen),
              ),
            ),
            const SizedBox(height: 32),
            StreamBuilder<bool>(
              stream: wm.isLoadingStream,
              initialData: false,
              builder: (ctx, snap) {
                final isLoading = snap.data ?? false;
                return Container(
                  height: 56,
                  decoration: isLoading ? null : NeonTheme.buttonGradient,
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              final amount = double.tryParse(_amountController.text);
                              final walletAddress = _walletController.text.trim();
                              if (amount != null && amount > 0) {
                                if (walletAddress.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(wm.i18n.walletAddressRequired)),
                                  );
                                } else {
                                  wm.startClaim(amount, walletAddress);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(wm.i18n.invalidAmount)),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLoading ? NeonTheme.darkCard : Colors.transparent,
                      foregroundColor: isLoading ? NeonTheme.brandBrightGreen : NeonTheme.darkBackground,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:
                        isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.brandBrightGreen),
                                ),
                              )
                            : Text(
                                wm.i18n.claimButton,
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
      ),
    );
  }

  Widget _buildConfirmationView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    NeonTheme.brandBrightGreen,
                    NeonTheme.brandDarkBlue,
                  ],
                ),
                boxShadow: NeonTheme.neonGlow,
              ),
              child: Icon(
                Icons.info_outline,
                size: 64,
                color: NeonTheme.darkBackground,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              wm.i18n.confirmTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                shadows: NeonTheme.neonTextShadow,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            StreamBuilder<Map<String, dynamic>>(
              stream: wm.claimInfoStream,
              initialData: {},
              builder: (ctx, snap) {
                final info = snap.data ?? {};
                return Container(
                  decoration: NeonTheme.cardGradient,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            wm.i18n.amountLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: Text(
                            '${info['amount'] ?? 0}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: NeonTheme.brandBrightGreen,
                              shadows: NeonTheme.neonTextShadow,
                            ),
                          ),
                        ),
                        Divider(color: NeonTheme.brandBrightGreen.withOpacity(0.3)),
                        ListTile(
                          title: Text(
                            wm.i18n.claimId,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: Text(
                            '${info['claim_id'] ?? ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: NeonTheme.mediumText,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        Divider(color: NeonTheme.brandBrightGreen.withOpacity(0.3)),
                        ListTile(
                          title: Text(
                            wm.i18n.walletAddress,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: SizedBox(
                            width: 150,
                            child: Text(
                              '${info['wallet_address'] ?? ''}',
                              style: TextStyle(
                                fontSize: 10,
                                color: NeonTheme.mediumText,
                                fontFamily: 'monospace',
                              ),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            StreamBuilder<bool>(
              stream: wm.isLoadingStream,
              initialData: false,
              builder: (ctx, snap) {
                final isLoading = snap.data ?? false;
                return Container(
                  height: 56,
                  decoration: isLoading ? null : NeonTheme.buttonGradient,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : wm.confirmClaim,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLoading ? NeonTheme.darkCard : Colors.transparent,
                      foregroundColor: isLoading ? NeonTheme.brandBrightGreen : NeonTheme.darkBackground,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:
                        isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.brandBrightGreen),
                                ),
                              )
                            : Text(
                                wm.i18n.confirmButton,
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
            const SizedBox(height: 16),
            TextButton(
              onPressed: wm.cancel,
              child: Text(
                wm.i18n.cancelButton,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      NeonTheme.brandBrightGreen,
                      NeonTheme.brandBrightGreen,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: NeonTheme.brandBrightGreen.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: NeonTheme.darkBackground,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                wm.i18n.successTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  shadows: NeonTheme.neonTextShadow,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                wm.i18n.successMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 56,
                decoration: NeonTheme.buttonGradient,
                child: ElevatedButton(
                  onPressed: wm.goBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: NeonTheme.darkBackground,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    wm.i18n.backToGame,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
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
}
