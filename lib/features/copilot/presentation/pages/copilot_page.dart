import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class CopilotPage extends StatelessWidget {
  const CopilotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('copilot.title'.tr()),
            Text('copilot.subtitle'.tr(),
                style: TextStyle(fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(children: [
              Icon(Icons.circle, color: AppColors.success, size: 8),
              SizedBox(width: 6),
              Text('Live', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPredictions(context, isDark),
          const SizedBox(height: 20),
          SectionHeader(title: 'copilot.top_actions'.tr()),
          const SizedBox(height: 12),
          _buildTopActions(context),
          const SizedBox(height: 20),
          SectionHeader(title: 'copilot.key_risks'.tr()),
          const SizedBox(height: 12),
          _buildRisks(context, isDark),
          const SizedBox(height: 20),
          SectionHeader(title: 'copilot.low_stock_items'.tr()),
          const SizedBox(height: 12),
          _buildLowStock(context, isDark),
          const SizedBox(height: 20),
          SectionHeader(title: 'copilot.ai_suggestions'.tr()),
          const SizedBox(height: 12),
          _buildAiSuggestions(context, isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPredictions(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A56DB), Color(0xFF3F83F8)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('AI Predictions for Today',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            _predCard('Predicted Sales', 'SAR 21,200', Icons.trending_up, '+14%'),
            const SizedBox(width: 10),
            _predCard('Predicted Waste', 'SAR 840', Icons.delete_outline, '-8%'),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _predCard('Delayed Orders', '3', Icons.timer_off_outlined, 'High Risk'),
            const SizedBox(width: 10),
            _predCard('New Complaints', '2', Icons.feedback_outlined, 'Monitor'),
          ]),
        ],
      ),
    );
  }

  Widget _predCard(String label, String value, IconData icon, String tag) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11))),
          ]),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 4),
          Text(tag, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        ]),
      ),
    );
  }

  Widget _buildTopActions(BuildContext context) {
    final actions = [
      _CopilotAction(1, 'Order 500g of Saffron – stock critical', AppColors.error, Icons.shopping_cart_outlined, 'copilot.priority_high'),
      _CopilotAction(2, 'Review Chef Hassan\'s overtime – cost overrun', AppColors.error, Icons.person_outline, 'copilot.priority_high'),
      _CopilotAction(3, 'Respond to 2 negative reviews on Google', AppColors.warning, Icons.star_border, 'copilot.priority_medium'),
      _CopilotAction(4, 'Update Thursday dinner menu – low margin items', AppColors.warning, Icons.menu_book_outlined, 'copilot.priority_medium'),
      _CopilotAction(5, 'Run flash promo – slow afternoon expected', AppColors.info, Icons.local_offer_outlined, 'copilot.priority_low'),
      _CopilotAction(6, 'Schedule deep clean for kitchen hood', AppColors.info, Icons.cleaning_services_outlined, 'copilot.priority_low'),
      _CopilotAction(7, 'Confirm supplier delivery for Friday', AppColors.info, Icons.local_shipping_outlined, 'copilot.priority_low'),
    ];
    return Column(
      children: actions.map((a) => _buildActionTile(context, a)).toList(),
    );
  }

  Widget _buildActionTile(BuildContext context, _CopilotAction action) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: action.color.withOpacity(0.12), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text('${action.rank}', style: TextStyle(fontWeight: FontWeight.w700, color: action.color, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: action.color.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
            child: Icon(action.icon, color: action.color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(action.text, style: const TextStyle(fontSize: 13))),
          const SizedBox(width: 8),
          StatusBadge(
            label: action.priority.split('.').last == 'priority_high' ? 'High' :
                   action.priority.split('.').last == 'priority_medium' ? 'Med' : 'Low',
            color: action.color,
          ),
        ],
      ),
    );
  }

  Widget _buildRisks(BuildContext context, bool isDark) {
    final risks = [
      _Risk('Saffron stock at critical level – operations at risk', AppColors.error, Icons.warning_rounded),
      _Risk('3 orders pending > 30 minutes in kitchen', AppColors.error, Icons.timer_off),
      _Risk('Gross margin dropped 4% this week', AppColors.warning, Icons.trending_down),
      _Risk('2 staff absent without notice – coverage gap', AppColors.warning, Icons.person_off_outlined),
    ];
    return Column(
      children: risks.map((r) => AlertCard(
        title: r.text,
        description: 'Detected by Copilot AI · Just now',
        color: r.color,
        icon: r.icon,
        time: 'Just now',
        isRead: false,
      )).toList(),
    );
  }

  Widget _buildLowStock(BuildContext context, bool isDark) {
    final items = [
      _StockItem('Saffron', '12g', '100g', 0.12, AppColors.error),
      _StockItem('Heavy Cream', '0.5L', '3L', 0.17, AppColors.error),
      _StockItem('Beef Tenderloin', '2kg', '8kg', 0.25, AppColors.warning),
      _StockItem('Cherry Tomatoes', '1.5kg', '4kg', 0.38, AppColors.warning),
    ];
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
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.inventory_2_outlined, color: item.color, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: item.progress,
                    backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                    valueColor: AlwaysStoppedAnimation<Color>(item.color),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ])),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(item.current, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: item.color)),
                  Text('of ${item.target}', style: TextStyle(fontSize: 10,
                      color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                ]),
              ]),
            ),
            if (!isLast) Divider(height: 1,
                color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildAiSuggestions(BuildContext context, bool isDark) {
    final suggestions = [
      'Push a 20% discount on Pasta Carbonara today – predicted overstock',
      'Schedule Friday morning for Beef Tenderloin delivery to maintain stock',
      'Reassign 2 kitchen staff to prep station – peak hours incoming at 12:30 PM',
    ];
    return Column(
      children: suggestions.asMap().entries.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.infoLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.info.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.info, size: 16),
            const SizedBox(width: 10),
            Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, color: AppColors.info))),
          ],
        ),
      )).toList(),
    );
  }
}

class _CopilotAction {
  final int rank; final String text, priority; final Color color; final IconData icon;
  _CopilotAction(this.rank, this.text, this.color, this.icon, this.priority);
}

class _Risk {
  final String text; final Color color; final IconData icon;
  _Risk(this.text, this.color, this.icon);
}

class _StockItem {
  final String name, current, target; final double progress; final Color color;
  _StockItem(this.name, this.current, this.target, this.progress, this.color);
}
