import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';
import 'package:restaurant_customer_app/core/theme/app_text_styles.dart';
import 'package:restaurant_customer_app/core/widgets/custom_button.dart';
import 'package:restaurant_customer_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurant_customer_app/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        context.go(RouteNames.home);
      }
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(Icons.restaurant, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                'Welcome Back!',
                style: AppTextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Order from your favourite restaurants\ndelivered to your door.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              GoogleSignInButton(
                isLoading: authState.isLoading,
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).signInWithGoogle();
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Continue as Guest',
                variant: ButtonVariant.outline,
                isFullWidth: true,
                isLoading: authState.isLoading,
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).signInAsGuest();
                },
              ),
              const SizedBox(height: 32),
              Text(
                'By continuing, you agree to our Terms & Privacy Policy.',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
