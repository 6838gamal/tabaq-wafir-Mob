// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (_, next) {
      next.whenData((driver) {
        if (driver != null) {
          if (driver.verificationStatus == 'approved') {
            context.go(RouteNames.home);
          } else {
            context.go(RouteNames.verify);
          }
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo / Illustration
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delivery_dining,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Driver App',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Deliver smarter, earn faster',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(flex: 3),
              if (authState.isLoading)
                const CircularProgressIndicator()
              else
                CustomButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata,
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
                  },
                ),
              if (authState.hasError) ...[
                const SizedBox(height: 12),
                Text(
                  authState.error.toString(),
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
