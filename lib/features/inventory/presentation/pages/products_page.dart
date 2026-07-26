import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int _catIndex = 0;
  final _cats = ['All', 'Meat', 'Dairy', 'Vegetables', 'Spices', 'Dry Goods'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('inventory.products'.tr())),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: AppSearchBar(hintText: 'Search products...', onFilterTap: () {}),
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _cats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) => ChoiceChip(
                label: Text(_cats[i]),
                selected: _catIndex == i,
                onSelected: (_) => setState(() => _catIndex = i),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: _catIndex == i ? Colors.white : null, fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockProducts.length,
              itemBuilder: (ctx, i) => _buildProductCard(_mockProducts[i], isDark),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(_Product p, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: p.statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Icon(p.icon, color: p.statusColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 3),
          Text('${p.qty} ${p.unit} · ${p.category}', style: TextStyle(fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          const SizedBox(height: 3),
          Text('Cost: ${p.cost}/unit', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          StatusBadge(label: p.stockStatus, color: p.statusColor),
          const SizedBox(height: 8),
          Row(children: [
            GestureDetector(onTap: () {}, child: const Icon(Icons.remove_circle_outline, size: 18, color: AppColors.primary)),
            const SizedBox(width: 8),
            GestureDetector(onTap: () {}, child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary)),
          ]),
        ]),
      ]),
    );
  }

  final _mockProducts = [
    _Product('Beef Tenderloin', '2', 'kg', 'Meat', 'SAR 85', 'Low Stock', AppColors.warning, Icons.set_meal),
    _Product('Saffron', '12', 'g', 'Spices', 'SAR 120', 'Critical', AppColors.error, Icons.grass),
    _Product('Heavy Cream', '500', 'ml', 'Dairy', 'SAR 15', 'Critical', AppColors.error, Icons.water_drop_outlined),
    _Product('Mozzarella', '3', 'kg', 'Dairy', 'SAR 40', 'In Stock', AppColors.success, Icons.water_drop_outlined),
    _Product('Cherry Tomatoes', '1.5', 'kg', 'Vegetables', 'SAR 12', 'Low Stock', AppColors.warning, Icons.eco),
    _Product('Pasta', '8', 'kg', 'Dry Goods', 'SAR 8', 'In Stock', AppColors.success, Icons.rice_bowl_outlined),
    _Product('Olive Oil', '3', 'L', 'Dry Goods', 'SAR 35', 'In Stock', AppColors.success, Icons.oil_barrel),
  ];
}

class _Product {
  final String name, qty, unit, category, cost, stockStatus; final Color statusColor; final IconData icon;
  _Product(this.name, this.qty, this.unit, this.category, this.cost, this.stockStatus, this.statusColor, this.icon);
}
