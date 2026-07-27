import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/offer.dart';
import '../providers/promotions_provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'promotion_status_toggle.dart';

class OfferCard extends ConsumerWidget {
  final Offer offer;
  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final df = DateFormat('dd MMM yyyy');

    Color statusColor;
    switch (offer.status) {
      case OfferStatus.active:
        statusColor = AppColors.success;
        break;
      case OfferStatus.scheduled:
        statusColor = AppColors.info;
        break;
      case OfferStatus.expired:
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textSecondaryLight;
    }

    String discountLabel;
    switch (offer.type) {
      case OfferType.percentage:
        discountLabel = '${offer.discountValue.toStringAsFixed(0)}% Off';
        break;
      case OfferType.fixedAmount:
        discountLabel = 'SAR ${offer.discountValue.toStringAsFixed(0)} Off';
        break;
      case OfferType.buyXGetY:
        discountLabel =
            'Buy ${offer.buyQuantity} Get ${offer.getQuantity} Free';
        break;
      case OfferType.freeItem:
        discountLabel = 'Free Item';
        break;
    }

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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    discountLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                PromotionStatusToggle(
                  isActive: offer.status == OfferStatus.active,
                  onChanged: (val) {
                    ref.read(offersProvider.notifier).toggleStatus(
                          offer.id,
                          val ? OfferStatus.active : OfferStatus.inactive,
                        );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              offer.title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (offer.description != null) ...[
              const SizedBox(height: 4),
              Text(
                offer.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 13, color: AppColors.textSecondaryLight),
                const SizedBox(width: 4),
                Text(
                  '${df.format(offer.startDate)} – ${df.format(offer.endDate)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondaryLight),
                ),
                const Spacer(),
                Icon(Icons.bar_chart, size: 13, color: AppColors.textSecondaryLight),
                const SizedBox(width: 4),
                Text(
                  '${offer.usageCount} used',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondaryLight),
                ),
              ],
            ),
            if (offer.minOrderAmount != null) ...[
              const SizedBox(height: 6),
              Text(
                'Min. order: SAR ${offer.minOrderAmount!.toStringAsFixed(0)}',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
