import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});
  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  String _selectedCategory = 'All';
  final List<_CartItem> _cart = [];
  String _paymentMethod = 'Card';

  final _categories = ['All', 'Main', 'Grills', 'Sides', 'Beverages', 'Desserts'];

  final _menuItems = [
    _MenuItem('Grilled Chicken', 68.0, 'Grills', Icons.outdoor_grill_outlined),
    _MenuItem('Beef Burger', 54.0, 'Main', Icons.lunch_dining_outlined),
    _MenuItem('Saffron Rice', 32.0, 'Sides', Icons.rice_bowl_outlined),
    _MenuItem('Caesar Salad', 38.0, 'Sides', Icons.eco_outlined),
    _MenuItem('Lamb Kofta', 84.0, 'Grills', Icons.outdoor_grill_outlined),
    _MenuItem('Chicken Shawarma', 42.0, 'Main', Icons.kebab_dining_outlined),
    _MenuItem('Hummus Plate', 28.0, 'Sides', Icons.breakfast_dining_outlined),
    _MenuItem('Lemonade', 18.0, 'Beverages', Icons.local_drink_outlined),
    _MenuItem('Mango Juice', 22.0, 'Beverages', Icons.local_drink_outlined),
    _MenuItem('Arabic Coffee', 12.0, 'Beverages', Icons.coffee_outlined),
    _MenuItem('Chocolate Lava Cake', 34.0, 'Desserts', Icons.cake_outlined),
    _MenuItem('Cheesecake', 30.0, 'Desserts', Icons.cake_outlined),
    _MenuItem('Pasta Carbonara', 62.0, 'Main', Icons.ramen_dining_outlined),
    _MenuItem('Garlic Bread', 16.0, 'Sides', Icons.breakfast_dining_outlined),
    _MenuItem('Tiramisu', 36.0, 'Desserts', Icons.cake_outlined),
    _MenuItem('Water Bottle', 8.0, 'Beverages', Icons.water_drop_outlined),
  ];

  List<_MenuItem> get _filtered {
    if (_selectedCategory == 'All') return _menuItems;
    return _menuItems.where((m) => m.category == _selectedCategory).toList();
  }

  double get _subtotal => _cart.fold(0, (s, c) => s + c.item.price * c.qty);
  double get _tax => _subtotal * 0.15;
  double get _total => _subtotal + _tax;

  void _addToCart(_MenuItem item) {
    setState(() {
      final idx = _cart.indexWhere((c) => c.item.name == item.name);
      if (idx >= 0) {
        _cart[idx] = _CartItem(_cart[idx].item, _cart[idx].qty + 1);
      } else {
        _cart.add(_CartItem(item, 1));
      }
    });
  }

  void _changeQty(int idx, int delta) {
    setState(() {
      final newQty = _cart[idx].qty + delta;
      if (newQty <= 0) {
        _cart.removeAt(idx);
      } else {
        _cart[idx] = _CartItem(_cart[idx].item, newQty);
      }
    });
  }

  int _qtyOf(String name) {
    final idx = _cart.indexWhere((c) => c.item.name == name);
    return idx >= 0 ? _cart[idx].qty : 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('pos.title'.tr()),
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
              Text('POS Active', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
      body: isWide
          ? Row(children: [
              Expanded(flex: 3, child: _buildMenu(isDark)),
              Container(width: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
              SizedBox(width: 340, child: _buildCart(isDark)),
            ])
          : Column(children: [
              Expanded(child: _buildMenu(isDark)),
              _buildCartDrawerButton(isDark),
            ]),
    );
  }

  Widget _buildMenu(bool isDark) {
    return Column(children: [
      // Category chips
      Container(
        height: 48,
        color: isDark ? AppColors.surfaceDark : Colors.white,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          children: _categories.map((c) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(c),
              selected: _selectedCategory == c,
              onSelected: (_) => setState(() => _selectedCategory = c),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: _selectedCategory == c ? Colors.white : null, fontSize: 12),
            ),
          )).toList(),
        ),
      ),
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.9,
          ),
          itemCount: _filtered.length,
          itemBuilder: (ctx, i) {
            final item = _filtered[i];
            final qty = _qtyOf(item.name);
            return GestureDetector(
              onTap: () => _addToCart(item),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: qty > 0 ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: qty > 0 ? 1.5 : 1,
                  ),
                ),
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('SAR ${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
                    ]),
                  ),
                  if (qty > 0)
                    Positioned(
                      top: 6, right: 6,
                      child: Container(
                        width: 20, height: 20,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Center(child: Text('$qty', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
                      ),
                    ),
                ]),
              ),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildCart(bool isDark) {
    return Container(
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(children: [
            const Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Order', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            if (_cart.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _cart.clear()),
                child: const Text('Clear', style: TextStyle(color: AppColors.error, fontSize: 12)),
              ),
          ]),
        ),
        Expanded(
          child: _cart.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.textSecondaryLight),
                  SizedBox(height: 8),
                  Text('Add items to start\nan order', textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                ]))
              : ListView.builder(
                  itemCount: _cart.length,
                  itemBuilder: (ctx, i) {
                    final c = _cart[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c.item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('SAR ${c.item.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                        ])),
                        Row(children: [
                          GestureDetector(
                            onTap: () => _changeQty(i, -1),
                            child: Container(
                              width: 26, height: 26,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.remove, size: 14, color: AppColors.primary),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('${c.qty}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          GestureDetector(
                            onTap: () => _changeQty(i, 1),
                            child: Container(
                              width: 26, height: 26,
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: const Icon(Icons.add, size: 14, color: Colors.white),
                            ),
                          ),
                        ]),
                        const SizedBox(width: 10),
                        Text('SAR ${(c.item.price * c.qty).toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      ]),
                    );
                  },
                ),
        ),
        // Totals & payment
        if (_cart.isNotEmpty) ...[
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(children: [
              _totalRow('Subtotal', 'SAR ${_subtotal.toStringAsFixed(2)}'),
              _totalRow('VAT (15%)', 'SAR ${_tax.toStringAsFixed(2)}'),
              _totalRow('Total', 'SAR ${_total.toStringAsFixed(2)}', bold: true, color: AppColors.primary),
            ]),
          ),
          // Payment method
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(children: ['Cash', 'Card', 'Online'].map((m) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(m, style: const TextStyle(fontSize: 11)),
                  selected: _paymentMethod == m,
                  onSelected: (_) => setState(() => _paymentMethod = m),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _paymentMethod == m ? Colors.white : null),
                ),
              ),
            )).toList()),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showCheckout(context),
                icon: const Icon(Icons.payment, color: Colors.white),
                label: Text('Charge SAR ${_total.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.kpiGreen, padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _totalRow(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _buildCartDrawerButton(bool isDark) {
    if (_cart.isEmpty) return const SizedBox.shrink();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => showModalBottomSheet(
              context: context, isScrollControlled: true,
              builder: (ctx) => SizedBox(height: 500, child: _buildCart(isDark)),
            ),
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            label: Text('View Cart (${_cart.length}) — SAR ${_total.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.kpiGreen, padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
      ),
    );
  }

  void _showCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Payment Confirmed', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle, color: AppColors.kpiGreen, size: 56),
          const SizedBox(height: 12),
          Text('SAR ${_total.toStringAsFixed(2)} — $_paymentMethod',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Order placed successfully', style: TextStyle(color: AppColors.textSecondaryLight)),
        ]),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _cart.clear());
            },
            child: const Text('New Order', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String name, category;
  final double price;
  final IconData icon;
  _MenuItem(this.name, this.price, this.category, this.icon);
}

class _CartItem {
  final _MenuItem item;
  final int qty;
  _CartItem(this.item, this.qty);
}
