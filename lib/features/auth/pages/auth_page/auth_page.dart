// lib/features/auth/pages/auth_page/auth_page.dart
import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/features/auth/pages/auth_page/di/auth_wm_builder.dart';
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Логотип/иконка
                Icon(Icons.gamepad, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 32),
                // Заголовок
                Text(
                  wm.i18n.pageTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  wm.i18n.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // Кнопка авторизации
                StreamBuilder<bool>(
                  stream: wm.isLoadingStream,
                  initialData: false,
                  builder: (ctx, snap) {
                    final isLoading = snap.data ?? false;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : wm.authenticate,
                        icon:
                            isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                                : const Icon(Icons.login),
                        label: Text(
                          isLoading ? wm.i18n.authenticating : wm.i18n.authenticateButton,
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Ошибка
                StreamBuilder<String?>(
                  stream: wm.errorStream,
                  initialData: null,
                  builder: (ctx, snap) {
                    final error = snap.data;
                    if (error != null && error.isNotEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700),
                            const SizedBox(width: 12),
                            Expanded(child: Text(error, style: TextStyle(color: Colors.red.shade700))),
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
    );
  }
}
