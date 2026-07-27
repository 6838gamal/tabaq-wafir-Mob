import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PromotionStatusToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;
  final String? activeLabel;
  final String? inactiveLabel;

  const PromotionStatusToggle({
    super.key,
    required this.isActive,
    required this.onChanged,
    this.activeLabel,
    this.inactiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isActive ? (activeLabel ?? 'Active') : (inactiveLabel ?? 'Inactive'),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.success : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: isActive,
          onChanged: onChanged,
          activeColor: AppColors.success,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
