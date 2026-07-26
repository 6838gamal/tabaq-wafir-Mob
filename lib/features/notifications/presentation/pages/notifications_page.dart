import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('nav.notifications'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _groupHeader('Today', isDark),
          AlertCard(title: 'New Order #1247', description: 'Table 5 placed an order · 3 items · SAR 185', color: AppColors.info, icon: Icons.receipt_long_outlined, time: '2 minutes ago', isRead: false),
          AlertCard(title: 'Stock Alert: Saffron', description: 'Saffron stock critically low (12g remaining)', color: AppColors.error, icon: Icons.inventory_2_outlined, time: '15 minutes ago', isRead: false),
          AlertCard(title: 'Shift Started', description: 'Hassan Ali checked in at 08:02 AM', color: AppColors.success, icon: Icons.person_outlined, time: '4 hours ago', isRead: true),
          _groupHeader('Yesterday', isDark),
          AlertCard(title: 'Daily Report Ready', description: 'Sales summary for Tuesday is available', color: AppColors.info, icon: Icons.bar_chart_outlined, time: 'Yesterday 11 PM', isRead: true),
          AlertCard(title: 'Invoice Mismatch', description: 'Supplier INV-2847 doesn\'t match the PO amount', color: AppColors.warning, icon: Icons.receipt_outlined, time: 'Yesterday 6 PM', isRead: true),
          AlertCard(title: 'New 5-Star Review', description: 'Customer Mohammed gave you 5 stars on Google', color: AppColors.success, icon: Icons.star, time: 'Yesterday 3 PM', isRead: true),
        ],
      ),
    );
  }

  Widget _groupHeader(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(label, style: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      )),
    );
  }
}
