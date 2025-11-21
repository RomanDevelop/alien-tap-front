import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/features/auth/pages/auth_page/di/auth_wm_builder.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'auth_wm.dart';

class AuthPage extends CoreMwwmWidget<AuthWidgetModel> {
  AuthPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createAuthWidgetModel(ctx));

  @override
  WidgetState<AuthPage, AuthWidgetModel> createWidgetState() => _AuthPageState();
}

class _AuthPageState extends WidgetState<AuthPage, AuthWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: NeonTheme.backgroundGradient,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [NeonTheme.brandLightGreen, NeonTheme.brandDarkBlue],
                        ),
                        boxShadow: [
                          BoxShadow(color: NeonTheme.brandLightGreen.withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                          BoxShadow(color: NeonTheme.brandDarkBlue.withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                        ],
                      ),
                      child: Center(
                        child:
                            kIsWeb
                                ? Image.network(
                                  _getWebAssetPath(),
                                  width: 190,
                                  height: 190,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('Error loading alien-logo.png (web): $error');
                                    return Image.asset(
                                      'assets/images/alien-logo.png',
                                      width: 190,
                                      height: 190,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return _buildPlaceholder();
                                      },
                                    );
                                  },
                                )
                                : Image.asset(
                                  'assets/images/alien-logo.png',
                                  width: 190,
                                  height: 190,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildPlaceholder();
                                  },
                                ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Text(
                      wm.i18n.pageTitle,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: NeonTheme.brandLightGreen,
                        shadows: [Shadow(color: NeonTheme.brandLightGreen.withOpacity(0.8), blurRadius: 15)],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          wm.i18n.subtitleLine1,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xFFB0B0B0)),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          wm.i18n.subtitleLine2,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xFFB0B0B0)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    StreamBuilder<bool>(
                      stream: wm.isLoadingStream,
                      initialData: false,
                      builder: (ctx, snap) {
                        final isLoading = snap.data ?? false;
                        return Container(
                          width: double.infinity,
                          height: 60,
                          decoration:
                              isLoading
                                  ? null
                                  : BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [NeonTheme.brandLightGreen, NeonTheme.brandBrightGreen],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : wm.authenticate,
                            icon:
                                isLoading
                                    ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.brandLightGreen),
                                      ),
                                    )
                                    : const Icon(Icons.login, size: 24),
                            label: Text(
                              isLoading ? wm.i18n.authenticating : wm.i18n.authenticateButton,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLoading ? NeonTheme.darkCard : Colors.transparent,
                              foregroundColor: isLoading ? NeonTheme.brandLightGreen : Colors.black,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    StreamBuilder<String?>(
                      stream: wm.errorStream,
                      initialData: null,
                      builder: (ctx, snap) {
                        final error = snap.data;
                        if (error != null && error.isNotEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: NeonTheme.darkCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
                              boxShadow: [
                                BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 15, spreadRadius: 1),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade400, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(error, style: TextStyle(color: Colors.red.shade300, fontSize: 14)),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getWebAssetPath() {
    if (kIsWeb) {
      return '/assets/images/alien-logo.png';
    }
    return 'assets/images/alien-logo.png';
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
      child: Icon(Icons.image_not_supported, size: 80, color: Colors.white.withOpacity(0.5)),
    );
  }
}
