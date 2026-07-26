import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class SuppliersPage extends ConsumerWidget {
  const SuppliersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final suppliers = ref.watch(suppliersProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _showForm(context, ref))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchBar(hintText: 'Search suppliers...', onFilterTap: () {}),
          ),
          // Stats row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(children: [
              _StatChip('${suppliers.length}', 'Total', AppColors.kpiBlue),
              const SizedBox(width: 8),
              _StatChip('${suppliers.where((s) => s.isActive).length}', 'Active', AppColors.kpiGreen),
              const SizedBox(width: 8),
              _StatChip(
                'SAR ${(suppliers.fold(0.0, (s, x) => s + x.totalPurchases) / 1000).toStringAsFixed(1)}K',
                'Total Spent', AppColors.kpiPurple,
              ),
            ]),
          ),
          Expanded(
            child: suppliers.isEmpty
                ? const Center(child: Text('No suppliers yet'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: suppliers.length,
                    itemBuilder: (ctx, i) => _SupplierCard(
                      supplier: suppliers[i],
                      isDark: isDark,
                      onTap: () => _showDetail(context, ref, suppliers[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Supplier', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Supplier? supplier}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _SupplierForm(supplier: supplier, ref: ref),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref, Supplier supplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _SupplierDetail(supplier: supplier, ref: ref),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatChip(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
    child: Column(children: [
      Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 13)),
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
    ]),
  );
}

class _SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final bool isDark;
  final VoidCallback onTap;
  const _SupplierCard({required this.supplier, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.kpiPurple.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Text(supplier.name[0].toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.kpiPurple)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
              if (supplier.category != null)
                StatusBadge(label: supplier.category!, color: AppColors.kpiBlue),
            ]),
            const SizedBox(height: 4),
            if (supplier.contactName != null)
              Text(supplier.contactName!, style: TextStyle(fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            Row(children: [
              if (supplier.phone != null) ...[
                Icon(Icons.phone_outlined, size: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                const SizedBox(width: 3),
                Text(supplier.phone!, style: TextStyle(fontSize: 11,
                  color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                const SizedBox(width: 10),
              ],
              if (supplier.city != null) ...[
                Icon(Icons.location_on_outlined, size: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                const SizedBox(width: 3),
                Text(supplier.city!, style: TextStyle(fontSize: 11,
                  color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
              ],
            ]),
          ])),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('SAR ${(supplier.totalPurchases / 1000).toStringAsFixed(1)}K',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.kpiGreen)),
            const SizedBox(height: 2),
            Text('Total Spent', style: TextStyle(fontSize: 10,
              color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
            if (supplier.lastPurchaseDate != null) ...[
              const SizedBox(height: 2),
              Text(_daysAgo(supplier.lastPurchaseDate!), style: TextStyle(fontSize: 10,
                color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
            ],
          ]),
        ]),
      ),
    );
  }

  String _daysAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}

class _SupplierDetail extends StatelessWidget {
  final Supplier supplier;
  final WidgetRef ref;
  const _SupplierDetail({required this.supplier, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      initialChildSize: 0.7, maxChildSize: 0.95, minChildSize: 0.4,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
          Center(child: Container(width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Row(children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: AppColors.kpiPurple.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
              alignment: Alignment.center,
              child: Text(supplier.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.kpiPurple)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(supplier.name, style: Theme.of(context).textTheme.titleLarge),
              if (supplier.category != null)
                StatusBadge(label: supplier.category!, color: AppColors.kpiBlue),
            ])),
          ]),
          const SizedBox(height: 20),
          // Stats
          Row(children: [
            Expanded(child: _MiniKpi('SAR ${(supplier.totalPurchases / 1000).toStringAsFixed(1)}K', 'Total Spent', AppColors.kpiGreen)),
            Expanded(child: _MiniKpi(supplier.paymentTerms ?? 'N/A', 'Payment Terms', AppColors.kpiBlue)),
            Expanded(child: _MiniKpi(supplier.lastPurchaseDate != null ? '${DateTime.now().difference(supplier.lastPurchaseDate!).inDays}d ago' : 'Never', 'Last Order', AppColors.kpiOrange)),
          ]),
          const Divider(height: 32),
          if (supplier.contactName != null) _Row(Icons.person_outline, 'Contact', supplier.contactName!),
          if (supplier.phone != null) _Row(Icons.phone_outlined, 'Phone', supplier.phone!),
          if (supplier.email != null) _Row(Icons.email_outlined, 'Email', supplier.email!),
          if (supplier.address != null) _Row(Icons.location_on_outlined, 'Address', supplier.address!),
          if (supplier.city != null) _Row(Icons.location_city_outlined, 'City', supplier.city!),
          if (supplier.notes != null) _Row(Icons.notes_outlined, 'Notes', supplier.notes!),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('New Purchase'),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            )),
          ]),
        ]),
      ),
    );
  }
}

class _MiniKpi extends StatelessWidget {
  final String value, label;
  final Color color;
  const _MiniKpi(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 14)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight), textAlign: TextAlign.center),
  ]);
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _Row(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColors.textSecondaryLight),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
    ]),
  );
}

class _SupplierForm extends StatefulWidget {
  final Supplier? supplier;
  final WidgetRef ref;
  const _SupplierForm({this.supplier, required this.ref});
  @override
  State<_SupplierForm> createState() => _SupplierFormState();
}

class _SupplierFormState extends State<_SupplierForm> {
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _category;
  String? _terms;
  final _categories = ['Meat & Poultry', 'Vegetables & Fruits', 'Dairy & Eggs', 'Dry Goods', 'Oils & Fats', 'Spices', 'Bakery', 'Beverages'];
  final _termsList = ['Net 7', 'Net 15', 'Net 30', 'Net 60', 'Cash on Delivery', 'Prepaid'];

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameCtrl.text = widget.supplier!.name;
      _contactCtrl.text = widget.supplier!.contactName ?? '';
      _phoneCtrl.text = widget.supplier!.phone ?? '';
      _emailCtrl.text = widget.supplier!.email ?? '';
      _cityCtrl.text = widget.supplier!.city ?? '';
      _notesCtrl.text = widget.supplier!.notes ?? '';
      _category = widget.supplier!.category;
      _terms = widget.supplier!.paymentTerms;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.supplier == null ? 'Add Supplier' : 'Edit Supplier',
          style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Supplier Name *')),
        const SizedBox(height: 12),
        TextField(controller: _contactCtrl, decoration: const InputDecoration(labelText: 'Contact Person')),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone'))),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email'))),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(controller: _cityCtrl, decoration: const InputDecoration(labelText: 'City'))),
          const SizedBox(width: 12),
          Expanded(child: DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (v) => setState(() => _category = v),
          )),
        ]),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _terms,
          decoration: const InputDecoration(labelText: 'Payment Terms'),
          items: _termsList.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (v) => setState(() => _terms = v),
        ),
        const SizedBox(height: 12),
        TextField(controller: _notesCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Notes')),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () {
            if (_nameCtrl.text.isEmpty) return;
            final s = Supplier(
              id: widget.supplier?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              restaurantId: 'r1', name: _nameCtrl.text,
              contactName: _contactCtrl.text.isNotEmpty ? _contactCtrl.text : null,
              phone: _phoneCtrl.text.isNotEmpty ? _phoneCtrl.text : null,
              email: _emailCtrl.text.isNotEmpty ? _emailCtrl.text : null,
              city: _cityCtrl.text.isNotEmpty ? _cityCtrl.text : null,
              category: _category, paymentTerms: _terms,
              notes: _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
              isActive: true, totalPurchases: widget.supplier?.totalPurchases ?? 0,
              lastPurchaseDate: widget.supplier?.lastPurchaseDate,
              createdAt: widget.supplier?.createdAt ?? DateTime.now(),
            );
            final suppliers = widget.ref.read(suppliersProvider);
            if (widget.supplier != null) {
              widget.ref.read(suppliersProvider.notifier).state = suppliers.map((x) => x.id == s.id ? s : x).toList();
            } else {
              widget.ref.read(suppliersProvider.notifier).state = [...suppliers, s];
            }
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Supplier ${widget.supplier == null ? 'added' : 'updated'}'), backgroundColor: AppColors.success));
          },
          child: Text(widget.supplier == null ? 'Add Supplier' : 'Save Changes'),
        )),
      ])),
    );
  }
}
