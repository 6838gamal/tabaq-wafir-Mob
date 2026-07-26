import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/rbac/user_role.dart';
import '../../../../l10n/app_l10n.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _showDemoPanel = false;
  UserRole _selectedDemoRole = UserRole.owner;

  @override
  void initState() {
    super.initState();
    // If already authenticated, go to dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider).isAuthenticated) {
        context.go(AppRoutes.dashboard);
      }
    });
  }

  Future<void> _signInWithGoogle() async {
    final success = await ref.read(authProvider.notifier).signInWithGoogle();
    if (mounted && success) {
      context.go(AppRoutes.dashboard);
    } else if (mounted && !success) {
      final msg = ref.read(authProvider).errorMessage ?? context.l10n.authGoogleSignInFailed;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _signInAsDemo() async {
    await ref.read(authProvider.notifier).signInAsDemo(_selectedDemoRole);
    if (mounted) context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    FadeInDown(
                      duration: const Duration(milliseconds: 700),
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
                        child: const Icon(Icons.restaurant_menu,
                            color: AppColors.primary, size: 48),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 150),
                      child: Text(
                        l10n.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        l10n.tagline,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Card
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceDark
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.authWelcomeBack,
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(l10n.authSignInSubtitle,
                                style: theme.textTheme.bodySmall),
                            const SizedBox(height: 28),

                            // Google Sign-In button
                            _GoogleSignInButton(
                              label: l10n.authSignInWithGoogle,
                              isLoading: isLoading,
                              onTap: _signInWithGoogle,
                            ),
                            const SizedBox(height: 16),

                            // Divider
                            Row(children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('or',
                                    style: theme.textTheme.bodySmall),
                              ),
                              const Expanded(child: Divider()),
                            ]),
                            const SizedBox(height: 16),

                            // Demo mode
                            _DemoPanel(
                              isOpen: _showDemoPanel,
                              selectedRole: _selectedDemoRole,
                              isLoading: isLoading,
                              label: l10n.authContinueAsDemo,
                              demoLabel: l10n.authDemoModeLabel,
                              onToggle: () =>
                                  setState(() => _showDemoPanel = !_showDemoPanel),
                              onRoleChanged: (r) =>
                                  setState(() => _selectedDemoRole = r),
                              onContinue: _signInAsDemo,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeIn(
                      delay: const Duration(milliseconds: 500),
                      child: Text(
                        '${l10n.appName} v${_version()}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
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

  String _version() => '1.0.0';
}

class _GoogleSignInButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _GoogleSignInButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoogleIcon(),
                  const SizedBox(width: 10),
                  Text(label,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const blue = Color(0xFF4285F4);
    const red = Color(0xFFEA4335);
    const yellow = Color(0xFFFBBC05);
    const green = Color(0xFF34A853);
    final p = Paint()..style = PaintingStyle.fill;
    // Simplified "G" icon as colored arcs
    p.color = blue;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), -0.52, 1.57, true, p);
    p.color = red;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 1.05, 1.57, true, p);
    p.color = yellow;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 2.62, 1.57, true, p);
    p.color = green;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), -2.09, 1.57, true, p);
    // White center
    p.color = Colors.white;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.35, p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _DemoPanel extends StatelessWidget {
  final bool isOpen;
  final UserRole selectedRole;
  final bool isLoading;
  final String label;
  final String demoLabel;
  final VoidCallback onToggle;
  final ValueChanged<UserRole> onRoleChanged;
  final VoidCallback onContinue;

  const _DemoPanel({
    required this.isOpen,
    required this.selectedRole,
    required this.isLoading,
    required this.label,
    required this.demoLabel,
    required this.onToggle,
    required this.onRoleChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: onToggle,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label),
                const SizedBox(width: 6),
                Icon(isOpen ? Icons.expand_less : Icons.expand_more, size: 18),
              ],
            ),
          ),
        ),
        if (isOpen) ...[
          const SizedBox(height: 12),
          Text(demoLabel, style: theme.textTheme.labelMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: UserRole.values.map((role) {
              final isSelected = role == selectedRole;
              return ChoiceChip(
                label: Text(role.displayName, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (_) => onRoleChanged(role),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: isLoading ? null : onContinue,
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text('Continue as ${selectedRole.displayName}'),
            ),
          ),
        ],
      ],
    );
  }
}
