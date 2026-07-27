import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _canNavigate = false; // true after the branding delay

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  Future<void> _startDelay() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _canNavigate = true);

    try {
      await ref
          .read(authProvider.notifier)
          .checkSession()
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      ref.read(authProvider.notifier).forceUnauthenticated();
    }

    // Explicit fallback: ref.listen fires on state *changes*, so if checkSession
    // resolved before the listener was registered we navigate here directly.
    if (mounted) _navigate(ref.read(authProvider));
  }

  void _navigate(AuthState auth) {
    if (!_canNavigate || !mounted) return;
    final status = auth.status;
    if (status == AuthStatus.authenticated) {
      context.go(AppRoutes.dashboard);
    } else if (status == AuthStatus.unauthenticated ||
        status == AuthStatus.error ||
        status == AuthStatus.sessionExpired) {
      context.go(AppRoutes.login);
    }
    // initial / loading → wait
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes and navigate once the branding delay is done.
    // Using ref.listen (not refreshListenable/redirect) avoids GoRouter timing issues.
    ref.listen<AuthState>(authProvider, (_, auth) => _navigate(auth));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 700),
                  child: const Text(
                    'Restaurant Copilot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    'Restaurant Operating Intelligence',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                FadeIn(
                  delay: const Duration(milliseconds: 900),
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
