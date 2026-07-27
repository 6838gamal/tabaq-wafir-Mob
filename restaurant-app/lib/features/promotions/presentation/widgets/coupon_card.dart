import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/coupon.dart';
import '../providers/promotions_provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'promotion_status_toggle.dart';

class CouponCard extends ConsumerWidget {
  final Coupon coupon;
  const CouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final df = DateFormat('dd MMM yyyy');

    final discountLabel = coupon.discountType == CouponDiscountType.percentage
        ? '${coupon.discountValue.toStringAsFixed(0)}% Off'
        : 'SAR ${coupon.discountValue.toStringAsFixed(0)} Off';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Coupon code chip
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: coupon.code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Code "${coupon.code}" copied!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.kpiPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.kpiPurple.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          coupon.code,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.kpiPurple,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.copy,
                            size: 13, color: AppColors.kpiPurple),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    discountLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                PromotionStatusToggle(
                  isActive: coupon.status == CouponStatus.active,
                  onChanged: (val) {
                    ref.read(couponsProvider.notifier).toggleStatus(
                          coupon.id,
                          val ? CouponStatus.active : CouponStatus.inactive,
                        );
                  },
                ),
              ],
            ),
            if (coupon.description != null) ...[
              const SizedBox(height: 8),
              Text(
                coupon.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                if (coupon.expiryDate != null)
                  _InfoChip(
                    icon: Icons.calendar_today_outlined,
                    label: 'Expires ${df.format(coupon.expiryDate!)}',
                  ),
                _InfoChip(
                  icon: Icons.bar_chart,
                  label: '${coupon.usageCount}'
                      '${coupon.usageLimit != null ? '/${coupon.usageLimit}' : ''} used',
                ),
                if (coupon.minOrderAmount != null)
                  _InfoChip(
                    icon: Icons.shopping_cart_outlined,
                    label:
                        'Min SAR ${coupon.minOrderAmount!.toStringAsFixed(0)}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondaryLight),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryLight),
        ),
      ],
    );
  }
}
