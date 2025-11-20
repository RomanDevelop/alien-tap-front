
import 'package:flutter/material.dart' hide WidgetState;
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
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [NeonTheme.neonCyan, NeonTheme.neonPurple],
                        ),
                        boxShadow: NeonTheme.neonGlow,
                      ),
                      child: Icon(Icons.gamepad, size: 80, color: NeonTheme.darkBackground),
                    ),
                    const SizedBox(height: 40),
                    
                    Text(
                      wm.i18n.pageTitle,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(shadows: NeonTheme.neonTextShadow),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(wm.i18n.subtitle, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                    const SizedBox(height: 48),
                    
                    StreamBuilder<bool>(
                      stream: wm.isLoadingStream,
                      initialData: false,
                      builder: (ctx, snap) {
                        final isLoading = snap.data ?? false;
                        return Container(
                          width: double.infinity,
                          height: 60,
                          decoration: isLoading ? null : NeonTheme.buttonGradient,
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : wm.authenticate,
                            icon:
                                isLoading
                                    ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(NeonTheme.neonCyan),
                                      ),
                                    )
                                    : const Icon(Icons.login, size: 24),
                            label: Text(
                              isLoading ? wm.i18n.authenticating : wm.i18n.authenticateButton,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLoading ? NeonTheme.darkCard : Colors.transparent,
                              foregroundColor: isLoading ? NeonTheme.neonCyan : NeonTheme.darkBackground,
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
}
