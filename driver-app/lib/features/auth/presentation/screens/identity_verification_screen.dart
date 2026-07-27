// lib/features/auth/presentation/screens/identity_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class IdentityVerificationScreen extends ConsumerWidget {
  const IdentityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identity Verification')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified_user, size: 64, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                'Verify Your Identity',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'To start delivering, we need to verify your identity and documents. '
                'This process usually takes 1-2 business days.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              _StepRow(
                step: 1,
                title: 'Upload Documents',
                description: 'Driving license, vehicle registration, insurance',
                isComplete: false,
              ),
              const SizedBox(height: 16),
              _StepRow(
                step: 2,
                title: 'Background Check',
                description: 'Automated identity verification',
                isComplete: false,
              ),
              const SizedBox(height: 16),
              _StepRow(
                step: 3,
                title: 'Approval',
                description: 'Start accepting deliveries',
                isComplete: false,
              ),
              const Spacer(),
              CustomButton(
                label: 'Upload Documents',
                onPressed: () => context.push(RouteNames.uploadDocs),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int step;
  final String title;
  final String description;
  final bool isComplete;

  const _StepRow({
    required this.step,
    required this.title,
    required this.description,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor:
              isComplete ? AppColors.success : AppColors.primary.withOpacity(0.1),
          child: isComplete
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : Text(
                  '$step',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
