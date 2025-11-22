import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'settings_wm.dart';
import 'di/settings_wm_builder.dart';

class SettingsPage extends CoreMwwmWidget<SettingsWidgetModel> {
  SettingsPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createSettingsWidgetModel(ctx));
  @override
  WidgetState<SettingsPage, SettingsWidgetModel> createWidgetState() => _SettingsPageState();
}

class _SettingsPageState extends WidgetState<SettingsPage, SettingsWidgetModel> {
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
                  child: Column(children: [_buildSettingsList(context)]),
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

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.language, color: NeonTheme.brandBrightGreen),
          title: Text(wm.i18n.language, style: TextStyle(color: NeonTheme.lightText)),
          trailing: Icon(Icons.chevron_right, color: NeonTheme.mediumText),
        ),
        ListTile(
          leading: Icon(Icons.notifications, color: NeonTheme.brandBrightGreen),
          title: Text(wm.i18n.notifications, style: TextStyle(color: NeonTheme.lightText)),
          trailing: Icon(Icons.chevron_right, color: NeonTheme.mediumText),
        ),
        ListTile(
          leading: Icon(Icons.palette, color: NeonTheme.brandBrightGreen),
          title: Text(wm.i18n.theme, style: TextStyle(color: NeonTheme.lightText)),
          trailing: Icon(Icons.chevron_right, color: NeonTheme.mediumText),
        ),
        ListTile(
          leading: Icon(Icons.security, color: NeonTheme.brandBrightGreen),
          title: Text(wm.i18n.security, style: TextStyle(color: NeonTheme.lightText)),
          trailing: Icon(Icons.chevron_right, color: NeonTheme.mediumText),
        ),
        ListTile(
          leading: Icon(Icons.info, color: NeonTheme.brandBrightGreen),
          title: Text(wm.i18n.about, style: TextStyle(color: NeonTheme.lightText)),
          trailing: Icon(Icons.chevron_right, color: NeonTheme.mediumText),
        ),
      ],
    );
  }
}
