import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() { _loading = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('auth.reset_password'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent ? _buildSuccess(theme) : _buildForm(theme),
      ),
    );
  }

  Widget _buildForm(ThemeData theme) => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.infoLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            const Icon(Icons.info_outline, color: AppColors.info, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('auth.reset_subtitle'.tr(), style: const TextStyle(fontSize: 13, color: AppColors.info))),
          ]),
        ),
        const SizedBox(height: 28),
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'auth.email'.tr(),
            prefixIcon: const Icon(Icons.email_outlined, size: 18),
          ),
          validator: (v) => (v?.isEmpty ?? true) ? 'common.required_field'.tr() : null,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: _loading ? null : _send,
            child: _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text('auth.send_reset'.tr()),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text('auth.back_to_login'.tr()),
          ),
        ),
      ],
    ),
  );

  Widget _buildSuccess(ThemeData theme) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
        child: const Icon(Icons.mark_email_read_outlined, color: AppColors.success, size: 48),
      ),
      const SizedBox(height: 24),
      Text('common.success'.tr(), style: theme.textTheme.headlineSmall),
      const SizedBox(height: 8),
      Text('Check your email for reset instructions', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
      const SizedBox(height: 32),
      ElevatedButton(onPressed: () => context.go(AppRoutes.login), child: Text('auth.back_to_login'.tr())),
    ]),
  );
}
