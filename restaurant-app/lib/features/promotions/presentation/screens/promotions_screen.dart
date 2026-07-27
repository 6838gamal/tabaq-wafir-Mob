import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/promotions_provider.dart';
import '../widgets/offer_card.dart';
import '../widgets/coupon_card.dart';
import 'create_offer_screen.dart';
import 'create_coupon_screen.dart';
import '../../../../core/theme/app_colors.dart';

class PromotionsScreen extends ConsumerWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(promotionTabProvider);
    final offers = ref.watch(offersProvider);
    final coupons = ref.watch(couponsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
        bottom: TabBar(
          controller: _TabController(tab, ref),
          onTap: (i) => ref.read(promotionTabProvider.notifier).state = i,
          tabs: [
            Tab(text: 'Offers (${offers.length})'),
            Tab(text: 'Coupons (${coupons.length})'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  tab == 0 ? const CreateOfferScreen() : const CreateCouponScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(tab == 0 ? 'New Offer' : 'New Coupon'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: tab == 0 ? _OffersTab(offers: offers) : _CouponsTab(coupons: coupons),
    );
  }
}

// Simple tab controller wrapper
class _TabController extends TabController {
  _TabController(int initialIndex, WidgetRef ref)
      : super(length: 2, vsync: _NoTickerProviderMixin(), initialIndex: initialIndex);
}

class _NoTickerProviderMixin implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class _OffersTab extends StatelessWidget {
  final List offers;
  const _OffersTab({required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const _EmptyState(
        icon: Icons.local_offer_outlined,
        message: 'No offers yet.\nTap + to create your first offer.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      itemCount: offers.length,
      itemBuilder: (_, i) => OfferCard(offer: offers[i]),
    );
  }
}

class _CouponsTab extends StatelessWidget {
  final List coupons;
  const _CouponsTab({required this.coupons});

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) {
      return const _EmptyState(
        icon: Icons.confirmation_number_outlined,
        message: 'No coupons yet.\nTap + to create your first coupon.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      itemCount: coupons.length,
      itemBuilder: (_, i) => CouponCard(coupon: coupons[i]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textSecondaryLight.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }
}
