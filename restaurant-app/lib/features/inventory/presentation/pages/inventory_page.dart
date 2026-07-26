import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dashboard = ref.watch(inventoryDashboardProvider);
    final lowStockItems = dashboard['low_stock_items'] as List<InventoryItem>;
    final expiringBatches = dashboard['expiring_soon'] as List<InventoryBatch>;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {},
            tooltip: 'Scan Barcode',
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {},
            tooltip: 'Export',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // KPI Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              KpiCard(
                title: 'Total Items',
                value: '${dashboard['total_items']}',
                subtitle: '${dashboard['total_categories']} categories',
                icon: Icons.inventory_2_outlined,
                color: AppColors.kpiBlue,
              ),
              KpiCard(
                title: 'Low / Out of Stock',
                value: '${(dashboard['low_stock_count'] as int) + (dashboard['out_of_stock_count'] as int)}',
                subtitle: '${dashboard['out_of_stock_count']} out of stock',
                icon: Icons.warning_amber_outlined,
                color: AppColors.warning,
                change: (dashboard['low_stock_count'] as int).toDouble(),
                isPositiveChange: false,
              ),
              KpiCard(
                title: 'Expiring Soon',
                value: '${dashboard['expiring_soon_count']}',
                subtitle: 'within 7 days',
                icon: Icons.timer_outlined,
                color: AppColors.kpiOrange,
              ),
              KpiCard(
                title: 'Stock Value',
                value: 'SAR ${_formatNum(dashboard['total_stock_value'] as double)}',
                icon: Icons.monetization_on_outlined,
                color: AppColors.kpiGreen,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick Access
          SectionHeader(title: 'Manage'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
            children: [
              _QuickCard(label: 'Items', icon: Icons.restaurant_menu_outlined, color: AppColors.kpiBlue, route: AppRoutes.products),
              _QuickCard(label: 'Stock Count', icon: Icons.fact_check_outlined, color: AppColors.kpiGreen, route: AppRoutes.stockCount),
              _QuickCard(label: 'Waste', icon: Icons.delete_outline, color: AppColors.error, route: AppRoutes.waste),
              _QuickCard(label: 'Suppliers', icon: Icons.store_outlined, color: AppColors.kpiPurple, route: AppRoutes.suppliers),
              _QuickCard(label: 'Purchases', icon: Icons.shopping_cart_outlined, color: AppColors.kpiTeal, route: AppRoutes.purchases),
              _QuickCard(label: 'Recipes', icon: Icons.menu_book_outlined, color: AppColors.kpiOrange, route: AppRoutes.recipes),
              _QuickCard(label: 'Expiry', icon: Icons.event_busy_outlined, color: AppColors.warning, route: AppRoutes.expiry),
              _QuickCard(label: 'Transfers', icon: Icons.swap_horiz, color: AppColors.info, route: AppRoutes.transfers),
              _QuickCard(label: 'Movements', icon: Icons.timeline_outlined, color: AppColors.secondary, route: AppRoutes.products),
            ],
          ),

          const SizedBox(height: 20),

          // Low Stock Alerts
          if (lowStockItems.isNotEmpty) ...[
            SectionHeader(
              title: 'Low Stock Alert',
              actionLabel: 'See All',
              onAction: () => context.go(AppRoutes.products),
            ),
            const SizedBox(height: 12),
            _LowStockList(items: lowStockItems.take(5).toList(), isDark: isDark),
            const SizedBox(height: 20),
          ],

          // Expiring Soon
          if (expiringBatches.isNotEmpty) ...[
            SectionHeader(
              title: 'Expiring Soon',
              actionLabel: 'View All',
              onAction: () => context.go(AppRoutes.expiry),
            ),
            const SizedBox(height: 12),
            _ExpiryList(batches: expiringBatches.take(5).toList(), isDark: isDark),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  String _formatNum(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

// ─── Quick Access Card ───────────────────────────────────────────────────────

class _QuickCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  const _QuickCard({required this.label, required this.icon, required this.color, required this.route});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Low Stock List ───────────────────────────────────────────────────────────

class _LowStockList extends StatelessWidget {
  final List<InventoryItem> items;
  final bool isDark;

  const _LowStockList({required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          final statusColor = item.stockStatus == StockStatus.out
              ? AppColors.error
              : item.stockStatus == StockStatus.critical
                  ? AppColors.kpiOrange
                  : AppColors.warning;
          final progress = item.minStock > 0 ? (item.currentStock / (item.minStock * 2)).clamp(0.0, 1.0) : 0.0;

          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.inventory_2_outlined, color: statusColor, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    'Current: ${item.currentStock}${item.unit}  Min: ${item.minStock}${item.unit}',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ])),
                const SizedBox(width: 10),
                StatusBadge(
                  label: item.stockStatus == StockStatus.out
                      ? 'OUT'
                      : item.stockStatus == StockStatus.critical
                          ? 'CRITICAL'
                          : 'LOW',
                  color: statusColor,
                ),
              ]),
            ),
            if (!isLast) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ]);
        }).toList(),
      ),
    );
  }
}

// ─── Expiry List ──────────────────────────────────────────────────────────────

class _ExpiryList extends StatelessWidget {
  final List<InventoryBatch> batches;
  final bool isDark;

  const _ExpiryList({required this.batches, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: batches.asMap().entries.map((e) {
          final b = e.value;
          final isLast = e.key == batches.length - 1;
          final color = b.expiryStatus == ExpiryStatus.expired
              ? AppColors.error
              : b.expiryStatus == ExpiryStatus.urgent
                  ? AppColors.kpiOrange
                  : AppColors.warning;

          String expiryText;
          if (b.daysUntilExpiry != null) {
            if (b.daysUntilExpiry! < 0) {
              expiryText = 'Expired ${b.daysUntilExpiry!.abs()} day(s) ago';
            } else if (b.daysUntilExpiry == 0) {
              expiryText = 'Expires today!';
            } else {
              expiryText = 'Expires in ${b.daysUntilExpiry} day(s)';
            }
          } else {
            expiryText = 'No expiry date';
          }

          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.event_busy_outlined, color: color, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b.itemName ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    'Qty: ${b.quantity} · Batch: ${b.batchNumber ?? '-'}',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  StatusBadge(
                    label: b.expiryStatus == ExpiryStatus.expired ? 'EXPIRED' : b.expiryStatus == ExpiryStatus.urgent ? 'URGENT' : 'WARNING',
                    color: color,
                  ),
                  const SizedBox(height: 4),
                  Text(expiryText, style: TextStyle(fontSize: 10, color: color)),
                ]),
              ]),
            ),
            if (!isLast) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ]);
        }).toList(),
      ),
    );
  }
}
