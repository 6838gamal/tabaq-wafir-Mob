import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';

class StockCountPage extends StatefulWidget {
  const StockCountPage({super.key});
  @override
  State<StockCountPage> createState() => _StockCountPageState();
}

class _StockCountPageState extends State<StockCountPage> {
  final _items = [
    _CountItem('Beef Tenderloin', 'kg', 5.0, null),
    _CountItem('Saffron', 'g', 42.0, null),
    _CountItem('Heavy Cream', 'ml', 2000.0, null),
    _CountItem('Mozzarella', 'kg', 4.5, null),
    _CountItem('Cherry Tomatoes', 'kg', 3.0, null),
    _CountItem('Pasta', 'kg', 10.0, null),
    _CountItem('Olive Oil', 'L', 5.0, null),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final done = _items.where((i) => i.counted != null).length;
    return Scaffold(
      appBar: AppBar(
        title: Text('inventory.stock_count'.tr()),
        actions: [
          TextButton(
            onPressed: done == _items.length ? () {} : null,
            child: const Text('Submit'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Stock Count Session', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              ])),
              Text('$done/${_items.length}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.primary)),
              const SizedBox(width: 8),
              const Text('items counted', style: TextStyle(fontSize: 12)),
            ]),
          ),
          LinearProgressIndicator(
            value: done / _items.length,
            backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 3,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (ctx, i) => _buildRow(_items[i], isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(_CountItem item, bool isDark) {
    final ctrl = TextEditingController(text: item.counted?.toString() ?? '');
    final diff = item.counted != null ? item.counted! - item.expected : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: diff == null ? (isDark ? AppColors.borderDark : AppColors.borderLight) :
                 diff < 0 ? AppColors.error.withOpacity(0.4) : AppColors.success.withOpacity(0.4)),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Text('Expected: ${item.expected} ${item.unit}', style: TextStyle(fontSize: 11,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          if (diff != null)
            Text('${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)} ${item.unit}',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: diff < 0 ? AppColors.error : AppColors.success)),
        ])),
        SizedBox(
          width: 100,
          child: TextField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              suffixText: item.unit,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
            onChanged: (v) => setState(() => item.counted = double.tryParse(v)),
          ),
        ),
      ]),
    );
  }
}

class _CountItem {
  final String name, unit; final double expected; double? counted;
  _CountItem(this.name, this.unit, this.expected, this.counted);
}
