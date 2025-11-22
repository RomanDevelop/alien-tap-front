import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'main_navigation_wm.dart';
import 'main_navigation_i18n.dart';

class MainNavigation extends CoreMwwmWidget<MainNavigationWidgetModel> {
  final Widget child;
  final String currentPath;

  MainNavigation({Key? key, required this.child, required this.currentPath})
    : super(
        key: key,
        widgetModelBuilder: (ctx) => MainNavigationWidgetModel(ctx, MainNavigationI18n(), WidgetModelDependencies()),
      );

  @override
  WidgetState<MainNavigation, MainNavigationWidgetModel> createWidgetState() => _MainNavigationState();
}

class _MainNavigationState extends WidgetState<MainNavigation, MainNavigationWidgetModel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      wm.updateSelectedIndex(widget.currentPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey<String>(widget.currentPath),
      body: RepaintBoundary(key: widget.key, child: widget.child),
      drawer: RepaintBoundary(child: _buildDrawer(context)),
      bottomNavigationBar: _buildBottomNavBar(context),
      extendBody: true,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: NeonTheme.darkSurface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [NeonTheme.brandDarkBlue, NeonTheme.brandMediumBlue],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    wm.i18n.appName,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: NeonTheme.brandBrightGreen, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v${wm.i18n.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: NeonTheme.mediumText),
                  ),
                ],
              ),
            ),
            const Divider(color: NeonTheme.brandMediumBlue),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    title: wm.i18n.profileMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToProfile();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.account_balance_wallet,
                    title: wm.i18n.walletMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToWallet();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: wm.i18n.settingsMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToSettings();
                    },
                  ),
                  const Divider(color: NeonTheme.brandMediumBlue),
                  _buildDrawerItem(
                    context,
                    icon: Icons.newspaper,
                    title: wm.i18n.newsMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToNews();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.trending_up,
                    title: wm.i18n.signalsMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToSignals();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.calendar_today,
                    title: wm.i18n.calendarMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToCalendar();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.card_membership,
                    title: wm.i18n.subscriptionMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToSubscription();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.school,
                    title: wm.i18n.educationMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToEducation();
                    },
                  ),
                  const Divider(color: NeonTheme.brandMediumBlue),
                  _buildDrawerItem(
                    context,
                    icon: Icons.currency_bitcoin,
                    title: wm.i18n.cryptoMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToCrypto();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.show_chart,
                    title: wm.i18n.stocksMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToStocks();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.currency_exchange,
                    title: wm.i18n.forexMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToForex();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.inventory,
                    title: wm.i18n.commoditiesMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToCommodities();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.analytics,
                    title: wm.i18n.optionsMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToOptions();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red.shade400 : NeonTheme.brandBrightGreen),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red.shade300 : NeonTheme.lightText, fontSize: 16),
      ),
      onTap: onTap,
      hoverColor: NeonTheme.brandMediumBlue.withOpacity(0.3),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return StreamBuilder<int>(
      stream: wm.selectedIndexStream,
      initialData: wm.selectedIndex,
      builder: (ctx, snap) {
        final selectedIndex = snap.data ?? 0;
        return RepaintBoundary(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [NeonTheme.darkSurface, NeonTheme.darkCard],
              ),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))],
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: wm.onTabTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: NeonTheme.brandBrightGreen,
              unselectedItemColor: NeonTheme.mediumText,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.touch_app), label: wm.i18n.gameTab),
                BottomNavigationBarItem(icon: const Icon(Icons.trending_up), label: wm.i18n.tradingTab),
                BottomNavigationBarItem(icon: const Icon(Icons.wallet), label: wm.i18n.portfolioTab),
                BottomNavigationBarItem(icon: const Icon(Icons.leaderboard), label: wm.i18n.leaderboardTab),
              ],
            ),
          ),
        );
      },
    );
  }
}
