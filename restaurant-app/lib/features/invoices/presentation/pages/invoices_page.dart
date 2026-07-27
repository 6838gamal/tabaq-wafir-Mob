import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});
  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  final _invoices = [
    _Invoice('INV-2851', 'Al-Rashidi Farms', 4200, 'Paid', '18 Jul 2026', '18 Jul 2026', AppColors.kpiGreen, 'Food Supplies'),
    _Invoice('INV-2850', 'Dairy Direct', 1800, 'Paid', '15 Jul 2026', '15 Jul 2026', AppColors.kpiGreen, 'Dairy Products'),
    _Invoice('INV-2849', 'Gulf Packaging Co.', 620, 'Pending', '20 Jul 2026', '27 Jul 2026', AppColors.warning, 'Packaging'),
    _Invoice('INV-2848', 'SpiceRoute Trading', 940, 'Pending', '19 Jul 2026', '26 Jul 2026', AppColors.warning, 'Spices'),
    _Invoice('INV-2847', 'Al-Rashidi Farms', 3850, 'Overdue', '10 Jul 2026', '17 Jul 2026', AppColors.error, 'Food Supplies'),
    _Invoice('INV-2846', 'CleanPro Supplies', 580, 'Paid', '8 Jul 2026', '8 Jul 2026', AppColors.kpiGreen, 'Cleaning'),
    _Invoice('INV-2845', 'Riyadh Beverage Co.', 2100, 'Overdue', '5 Jul 2026', '12 Jul 2026', AppColors.error, 'Beverages'),
    _Invoice('INV-2844', 'Omega Equipment', 1200, 'Paid', '3 Jul 2026', '3 Jul 2026', AppColors.kpiGreen, 'Maintenance'),
  ];

  List<_Invoice> get _filtered {
    var list = _invoices;
    if (_search.isNotEmpty) {
      list = list.where((i) =>
          i.number.toLowerCase().contains(_search.toLowerCase()) ||
          i.supplier.toLowerCase().contains(_search.toLowerCase())).toList();
    }
    final idx = _tab.index;
    if (idx == 1) return list.where((i) => i.status == 'Pending').toList();
    if (idx == 2) return list.where((i) => i.status == 'Overdue').toList();
    return list;
  }

  double get _totalOutstanding =>
      _invoices.where((i) => i.status != 'Paid').fold(0, (s, i) => s + i.amount);
  double get _totalPaid =>
      _invoices.where((i) => i.status == 'Paid').fold(0, (s, i) => s + i.amount);
  int get _overdueCount => _invoices.where((i) => i.status == 'Overdue').length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('invoices.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            onTap: (_) => setState(() {}),
            tabs: [
              Tab(text: 'All (${_invoices.length})'),
              Tab(text: 'Pending (${_invoices.where((i) => i.status == 'Pending').length})'),
              Tab(text: 'Overdue ($_overdueCount)'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary
          Container(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(children: [
              Expanded(child: _summaryChip('Paid', 'SAR ${_totalPaid ~/ 1000}K', AppColors.kpiGreen)),
              const SizedBox(width: 10),
              Expanded(child: _summaryChip('Outstanding', 'SAR ${_totalOutstanding ~/ 1000}K', AppColors.warning)),
              const SizedBox(width: 10),
              Expanded(child: _summaryChip('Overdue', '$_overdueCount invoices', AppColors.error)),
            ]),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: AppSearchBar(
              hintText: 'Search invoices...',
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No invoices',
                    subtitle: 'No invoices match your filter.')
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => _buildCard(_filtered[i], isDark),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('invoices.add'.tr(), style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _summaryChip(String label, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
      ]),
    );
  }

  Widget _buildCard(_Invoice inv, bool isDark) {
    return GestureDetector(
      onTap: () => _showDetail(context, inv),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: inv.status == 'Overdue'
                ? AppColors.error.withOpacity(0.4)
                : isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: inv.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.receipt_long_outlined, color: inv.statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(inv.number,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(width: 8),
              StatusBadge(label: inv.status, color: inv.statusColor),
            ]),
            const SizedBox(height: 3),
            Text(inv.supplier,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight)),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.category_outlined, size: 11, color: AppColors.textSecondaryLight),
              const SizedBox(width: 4),
              Text(inv.category,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              const SizedBox(width: 10),
              const Icon(Icons.calendar_today_outlined,
                  size: 11, color: AppColors.textSecondaryLight),
              const SizedBox(width: 4),
              Text('Due ${inv.dueDate}',
                  style: TextStyle(
                    fontSize: 11,
                    color: inv.status == 'Overdue' ? AppColors.error : AppColors.textSecondaryLight,
                    fontWeight: inv.status == 'Overdue' ? FontWeight.w600 : null,
                  )),
            ]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('SAR ${inv.amount.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text(inv.issueDate,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
          ]),
        ]),
      ),
    );
  }

  void _showDetail(BuildContext context, _Invoice inv) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5, expand: false,
        builder: (_, sc) => ListView(
          controller: sc,
          padding: const EdgeInsets.all(24),
          children: [
            Row(children: [
              Expanded(child: Text(inv.number, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
              StatusBadge(label: inv.status, color: inv.statusColor),
            ]),
            const SizedBox(height: 20),
            _detailRow('Supplier', inv.supplier, Icons.store_outlined),
            _detailRow('Category', inv.category, Icons.category_outlined),
            _detailRow('Issue Date', inv.issueDate, Icons.calendar_today_outlined),
            _detailRow('Due Date', inv.dueDate, Icons.event_outlined),
            _detailRow('Amount', 'SAR ${inv.amount.toStringAsFixed(2)}', Icons.payments_outlined),
            const SizedBox(height: 20),
            if (inv.status != 'Paid')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Mark as Paid', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.kpiGreen),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('invoices.add'.tr(), style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Supplier Name', prefixIcon: Icon(Icons.store_outlined))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Amount (SAR)', prefixIcon: Icon(Icons.payments_outlined)), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Due Date', prefixIcon: Icon(Icons.calendar_today_outlined))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: Text('common.save'.tr()))),
        ]),
      ),
    );
  }
}

class _Invoice {
  final String number, supplier, status, issueDate, dueDate, category;
  final double amount;
  final Color statusColor;
  _Invoice(this.number, this.supplier, this.amount, this.status, this.issueDate,
      this.dueDate, this.statusColor, this.category);
}
