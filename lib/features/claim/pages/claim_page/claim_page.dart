// lib/features/claim/pages/claim_page/claim_page.dart
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/features/claim/pages/claim_page/di/claim_wm_builder.dart';
import 'package:alien_tap/features/claim/pages/claim_page/claim_state.dart';
import 'claim_wm.dart';

class ClaimPage extends CoreMwwmWidget<ClaimWidgetModel> {
  ClaimPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createClaimWidgetModel(ctx));

  @override
  WidgetState<ClaimPage, ClaimWidgetModel> createWidgetState() => _ClaimPageState();
}

class _ClaimPageState extends WidgetState<ClaimPage, ClaimWidgetModel> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(wm.i18n.pageTitle)),
      body: StreamBuilder<ClaimState>(
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
    );
  }

  Widget _buildInputView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(wm.i18n.enterAmount, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          StreamBuilder<int>(
            stream: wm.currentScoreStream,
            initialData: 0,
            builder: (ctx, snap) {
              final score = snap.data ?? 0;
              return Text('${wm.i18n.availableScore}: $score', style: Theme.of(context).textTheme.bodyLarge);
            },
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: wm.i18n.amountLabel,
              hintText: wm.i18n.amountHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          StreamBuilder<bool>(
            stream: wm.isLoadingStream,
            initialData: false,
            builder: (ctx, snap) {
              final isLoading = snap.data ?? false;
              return ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : () {
                          final amount = double.tryParse(_amountController.text);
                          if (amount != null && amount > 0) {
                            wm.startClaim(amount);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(wm.i18n.invalidAmount)));
                          }
                        },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child:
                    isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(wm.i18n.claimButton),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.info_outline, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text(wm.i18n.confirmTitle, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          StreamBuilder<Map<String, dynamic>>(
            stream: wm.claimInfoStream,
            initialData: {},
            builder: (ctx, snap) {
              final info = snap.data ?? {};
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(title: Text(wm.i18n.amountLabel), trailing: Text('${info['amount'] ?? 0}')),
                      ListTile(
                        title: Text(wm.i18n.claimId),
                        trailing: Text('${info['claim_id'] ?? ''}', style: const TextStyle(fontSize: 12)),
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
              return ElevatedButton(
                onPressed: isLoading ? null : wm.confirmClaim,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child:
                    isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(wm.i18n.confirmButton),
              );
            },
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: wm.cancel, child: Text(wm.i18n.cancelButton)),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(wm.i18n.successTitle, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(wm.i18n.successMessage, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: wm.goBack, child: Text(wm.i18n.backToGame)),
          ],
        ),
      ),
    );
  }
}
