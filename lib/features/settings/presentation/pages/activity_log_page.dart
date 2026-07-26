import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';

class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({super.key});

  final _logs = const [
    _Log('Received Stock', 'Beef Tenderloin +5kg received and logged', 'Hassan Ali', '10:30 AM', Icons.arrow_downward, AppColors.success),
    _Log('Order Cancelled', 'Order #1242 cancelled — Customer request', 'Ahmed M.', '09:45 AM', Icons.cancel_outlined, AppColors.error),
    _Log('Login', 'Admin login from iPhone 14 · Riyadh', 'Ahmed Al-Rashidi', '08:02 AM', Icons.login, AppColors.info),
    _Log('Price Update', 'Grilled Chicken price updated: SAR 45 → SAR 48', 'Ahmed Al-Rashidi', 'Yesterday 6 PM', Icons.price_change_outlined, AppColors.warning),
    _Log('Staff Added', 'New employee Noura Hassan onboarded', 'Admin', 'Yesterday 2 PM', Icons.person_add_outlined, AppColors.kpiGreen),
    _Log('Waste Logged', 'Cherry Tomatoes 2kg spoiled and recorded', 'Hassan Ali', 'Yesterday 9 AM', Icons.delete_outline, AppColors.warning),
    _Log('Invoice Paid', 'INV-2845 paid — SAR 3,600 to Kitchen Equipment', 'Admin', '2 days ago', Icons.check_circle_outline, AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.activity_log'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _logs.length,
        itemBuilder: (ctx, i) {
          final log = _logs[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: log.color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Icon(log.icon, color: log.color, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(log.action, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                Text(log.description, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.person_outline, size: 11, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 4),
                  Text(log.user, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                ]),
              ])),
              Text(log.time, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
            ]),
          );
        },
      ),
    );
  }
}

class _Log {
  final String action, description, user, time;
  final IconData icon; final Color color;
  const _Log(this.action, this.description, this.user, this.time, this.icon, this.color);
}
