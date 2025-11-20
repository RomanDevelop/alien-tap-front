
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'package:intl/intl.dart';
import 'profile_wm.dart';
import 'di/profile_wm_builder.dart';

class ProfilePage extends CoreMwwmWidget<ProfileWidgetModel> {
  ProfilePage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createProfileWidgetModel(ctx));

  @override
  WidgetState<ProfilePage, ProfileWidgetModel> createWidgetState() => _ProfilePageState();
}

class _ProfilePageState extends WidgetState<ProfilePage, ProfileWidgetModel> {
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
                      children: [
                        _buildProfileHeader(context),
                        const SizedBox(height: 32),
                        _buildBalanceCard(context),
                        const SizedBox(height: 24),
                        _buildReferralSection(context),
                        const SizedBox(height: 32),
                        _buildOperationsHistory(context),
                        const SizedBox(height: 32),
                        _buildLogoutButton(context),
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
          icon: Icon(Icons.arrow_back, color: NeonTheme.brandBrightGreen),
          onPressed: wm.goBack,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: wm.userProfileStream,
      initialData: {},
      builder: (ctx, snap) {
        final profile = snap.data ?? {};
        final username = profile['username'] as String? ?? 'User';
        final userId = profile['userId'] as String? ?? '';

        return Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [NeonTheme.brandBrightGreen, NeonTheme.brandDarkBlue],
                ),
                boxShadow: NeonTheme.neonGlow,
              ),
              child: Icon(
                Icons.person,
                size: 50,
                color: NeonTheme.darkBackground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: NeonTheme.lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${wm.i18n.userId}: $userId',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: NeonTheme.mediumText,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: wm.userProfileStream,
      initialData: {},
      builder: (ctx, snap) {
        final profile = snap.data ?? {};
        final balance = profile['alenBalance'] as double? ?? 0.0;

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
            border: Border.all(color: NeonTheme.brandBrightGreen.withOpacity(0.5), width: 2),
            boxShadow: NeonTheme.neonGlow,
          ),
          child: Column(
            children: [
              Text(
                wm.i18n.balance,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NeonTheme.mediumText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${balance.toStringAsFixed(2)} ALEN',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: NeonTheme.brandBrightGreen,
                  shadows: NeonTheme.neonTextShadow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReferralSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: NeonTheme.cardGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            wm.i18n.referralLink,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: NeonTheme.lightText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<String?>(
            stream: wm.referralLinkStream,
            initialData: null,
            builder: (ctx, linkSnap) {
              final link = linkSnap.data;
              if (link == null) {
                return StreamBuilder<bool>(
                  stream: wm.isLoadingStream,
                  initialData: false,
                  builder: (ctx, loadingSnap) {
                    final isLoading = loadingSnap.data ?? false;
                    return Container(
                      height: 56,
                      decoration: NeonTheme.buttonGradient,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : wm.generateReferralLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: NeonTheme.darkBackground,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.darkBackground),
                                ),
                              )
                            : Text(
                                wm.i18n.createReferralLink,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    );
                  },
                );
              }

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NeonTheme.darkCard.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: NeonTheme.brandBrightGreen.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            link,
                            style: TextStyle(
                              color: NeonTheme.lightText,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.copy, color: NeonTheme.brandBrightGreen, size: 20),
                          onPressed: () {
                            wm.copyReferralLink();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(wm.i18n.linkCopied),
                                backgroundColor: NeonTheme.darkCard,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOperationsHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          wm.i18n.operationsHistory,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: NeonTheme.lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: wm.operationsHistoryStream,
          initialData: [],
          builder: (ctx, snap) {
            final history = snap.data ?? [];
            if (history.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: NeonTheme.darkCard.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    wm.i18n.noHistory,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: NeonTheme.mediumText,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: history.map((op) => _buildOperationCard(context, op)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOperationCard(BuildContext context, Map<String, dynamic> operation) {
    final type = operation['type'] as String? ?? '';
    final amount = operation['amount'] as double? ?? 0.0;
    final date = operation['date'] as DateTime? ?? DateTime.now();
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    IconData icon;
    Color color;
    String typeLabel;
    
    switch (type) {
      case 'withdraw':
        icon = Icons.arrow_upward;
        color = Colors.red;
        typeLabel = 'Вывод';
        break;
      case 'transfer':
        icon = Icons.swap_horiz;
        color = NeonTheme.brandBrightGreen;
        typeLabel = 'Перевод';
        break;
      case 'claim':
        icon = Icons.monetization_on;
        color = NeonTheme.brandBrightGreen;
        typeLabel = 'Забрать';
        break;
      default:
        icon = Icons.info;
        color = NeonTheme.mediumText;
        typeLabel = type;
    }

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
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: NeonTheme.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateFormat.format(date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NeonTheme.mediumText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${amount.toStringAsFixed(2)} ALEN',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.8), Colors.red],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: wm.logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          wm.i18n.logout,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

