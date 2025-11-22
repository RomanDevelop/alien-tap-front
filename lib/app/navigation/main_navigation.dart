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
    // Обертываем child в Scaffold с drawer и bottomNavigationBar
    // Если child уже имеет Scaffold, он будет заменен
    return Scaffold(
      body: widget.child,
      drawer: _buildDrawer(context),
      bottomNavigationBar: _buildBottomNavBar(context),
      extendBody: true, // Позволяет контенту расширяться под bottomNavigationBar
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [NeonTheme.brandDarkBlue, NeonTheme.brandMediumBlue],
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_circle, size: 48, color: NeonTheme.brandBrightGreen),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alien Tap',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: NeonTheme.brandBrightGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Игрок',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: NeonTheme.mediumText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                    title: wm.i18n.claimMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToClaim();
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.water_drop,
                    title: wm.i18n.liquidityMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.navigateToLiquidity();
                    },
                  ),
                  const Divider(color: NeonTheme.brandMediumBlue),
                  _buildDrawerItem(
                    context,
                    icon: Icons.logout,
                    title: wm.i18n.logoutMenu,
                    onTap: () {
                      Navigator.of(context).pop();
                      wm.logout();
                    },
                    isDestructive: true,
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [NeonTheme.darkSurface, NeonTheme.darkCard],
            ),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -2))],
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
              BottomNavigationBarItem(icon: Icon(Icons.touch_app), label: wm.i18n.gameTab),
              BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: wm.i18n.tradingTab),
              BottomNavigationBarItem(icon: Icon(Icons.wallet), label: wm.i18n.portfolioTab),
              BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: wm.i18n.leaderboardTab),
            ],
          ),
        );
      },
    );
  }
}
