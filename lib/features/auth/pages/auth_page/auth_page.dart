import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lottie/lottie.dart';
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
                                ? Lottie.network(
                                  _getLottieWebPath(),
                                  width: 190,
                                  height: 190,
                                  fit: BoxFit.contain,
                                  repeat: true,
                                  animate: true,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Lottie.asset(
                                      'assets/animation/Astronaut Smartphone.json',
                                      width: 190,
                                      height: 190,
                                      fit: BoxFit.contain,
                                      repeat: true,
                                      animate: true,
                                    );
                                  },
                                )
                                : Lottie.asset(
                                  'assets/animation/Astronaut Smartphone.json',
                                  width: 190,
                                  height: 190,
                                  fit: BoxFit.contain,
                                  repeat: true,
                                  animate: true,
                                ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    _TypewriterText(
                      text: wm.i18n.pageTitle,
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
                        return _PulsatingButton(
                          isLoading: isLoading,
                          child: Container(
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

  String _getLottieWebPath() {
    if (kIsWeb) {
      return '/assets/assets/animation/Astronaut%20Smartphone.json';
    }
    return 'assets/animation/Astronaut Smartphone.json';
  }
}

class _TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const _TypewriterText({required this.text, this.style, this.textAlign = TextAlign.center});

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  String _displayText = '';
  int _currentIndex = 0;
  bool _isDeleting = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _startTyping() {
    if (_isDisposed) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && !_isDisposed) {
        _type();
      }
    });
  }

  void _type() {
    if (!mounted || _isDisposed) return;

    if (!_isDeleting && _currentIndex < widget.text.length) {
      if (!mounted || _isDisposed) return;
      setState(() {
        _displayText = widget.text.substring(0, _currentIndex + 1);
        _currentIndex++;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && !_isDisposed) {
          _type();
        }
      });
    } else if (!_isDeleting && _currentIndex >= widget.text.length) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_isDisposed) {
          setState(() {
            _isDeleting = true;
          });
          _type();
        }
      });
    } else if (_isDeleting && _currentIndex > 0) {
      if (!mounted || _isDisposed) return;
      setState(() {
        _displayText = widget.text.substring(0, _currentIndex - 1);
        _currentIndex--;
      });
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted && !_isDisposed) {
          _type();
        }
      });
    } else if (_isDeleting && _currentIndex == 0) {
      if (!mounted || _isDisposed) return;
      setState(() {
        _isDeleting = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_isDisposed) {
          _type();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayText, style: widget.style, textAlign: widget.textAlign);
  }
}

class _PulsatingButton extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const _PulsatingButton({required this.child, required this.isLoading});

  @override
  State<_PulsatingButton> createState() => _PulsatingButtonState();
}

class _PulsatingButtonState extends State<_PulsatingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: widget.child);
      },
      child: widget.child,
    );
  }
}
