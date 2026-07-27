import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class AuditLogPage extends StatefulWidget {
  const AuditLogPage({super.key});
  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  String _search = '';
  String _selectedAction = 'All';
  final _actionFilters = ['All', 'Login', 'Order', 'Inventory', 'Settings', 'Finance'];

  final _logs = [
    _LogEntry('Hassan Ali', 'Marked Order #1243 as Ready', 'Order', AppColors.kpiBlue, Icons.restaurant_outlined, 'Today 10:15 AM'),
    _LogEntry('Sara Khalid', 'Logged in from Web (Chrome)', 'Login', AppColors.kpiGreen, Icons.login_outlined, 'Today 09:00 AM'),
    _LogEntry('Noura Hassan', 'Updated stock: Saffron +200g', 'Inventory', AppColors.kpiOrange, Icons.inventory_2_outlined, 'Today 08:45 AM'),
    _LogEntry('Admin', 'Changed VAT rate from 14% to 15%', 'Settings', AppColors.kpiPurple, Icons.settings_outlined, 'Today 08:30 AM'),
    _LogEntry('Omar Nasser', 'Logged in from Mobile', 'Login', AppColors.kpiGreen, Icons.login_outlined, 'Today 07:45 AM'),
    _LogEntry('Admin', 'Generated Invoice INV-2851', 'Finance', AppColors.kpiTeal, Icons.receipt_long_outlined, 'Yesterday 11:55 PM'),
    _LogEntry('Sara Khalid', 'Processed refund — Order #1220 (SAR 94.5)', 'Finance', AppColors.error, Icons.assignment_return_outlined, 'Yesterday 06:30 PM'),
    _LogEntry('Noura Hassan', 'Added new product: Quinoa Salad', 'Inventory', AppColors.kpiOrange, Icons.add_circle_outline, 'Yesterday 04:12 PM'),
    _LogEntry('Admin', 'Created coupon: SUMMER15', 'Settings', AppColors.kpiPurple, Icons.local_offer_outlined, 'Yesterday 02:00 PM'),
    _LogEntry('Hassan Ali', 'Logged waste: Beef 0.8kg', 'Inventory', AppColors.warning, Icons.delete_outline, 'Yesterday 01:30 PM'),
    _LogEntry('Ahmed Mohammed', 'Logged in from Mobile', 'Login', AppColors.kpiGreen, Icons.login_outlined, 'Yesterday 08:15 AM'),
    _LogEntry('Admin', 'Updated branch hours — North Branch', 'Settings', AppColors.kpiPurple, Icons.access_time_outlined, '25 Jul 2026 07:00 PM'),
    _LogEntry('Sara Khalid', 'Created new reservation for Khalid Rashidi', 'Order', AppColors.kpiBlue, Icons.event_outlined, '25 Jul 2026 05:30 PM'),
    _LogEntry('Noura Hassan', 'Logged stock count — Main Branch', 'Inventory', AppColors.kpiOrange, Icons.fact_check_outlined, '25 Jul 2026 11:00 AM'),
    _LogEntry('Admin', 'Added new employee: Yasser Ibrahim', 'Settings', AppColors.kpiPurple, Icons.person_add_outlined, '24 Jul 2026 09:00 AM'),
  ];

  List<_LogEntry> get _filtered {
    var list = _logs;
    if (_selectedAction != 'All') {
      list = list.where((l) => l.action == _selectedAction).toList();
    }
    if (_search.isNotEmpty) {
      list = list.where((l) =>
          l.user.toLowerCase().contains(_search.toLowerCase()) ||
          l.description.toLowerCase().contains(_search.toLowerCase())).toList();
    }
    return list;
  }

  // Group by date header
  List<_LogEntry> get _grouped => _filtered;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('audit_log.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
      ),
      body: Column(children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: AppSearchBar(
            hintText: 'Search logs...',
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        // Action filter chips
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _actionFilters.map((f) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f),
                selected: _selectedAction == f,
                onSelected: (_) => setState(() => _selectedAction = f),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: _selectedAction == f ? Colors.white : null, fontSize: 12),
              ),
            )).toList(),
          ),
        ),
        // Stats bar
        Container(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Row(children: [
            const Icon(Icons.list_alt_outlined, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text('${_filtered.length} entries', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const Spacer(),
            const Icon(Icons.access_time_outlined, size: 13, color: AppColors.textSecondaryLight),
            const SizedBox(width: 4),
            const Text('Realtime', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
          ]),
        ),
        Expanded(
          child: _grouped.isEmpty
              ? EmptyState(
                  icon: Icons.history_outlined,
                  title: 'No audit logs',
                  subtitle: _search.isNotEmpty ? 'No results for "$_search"' : 'No entries match this filter.')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  itemCount: _grouped.length,
                  itemBuilder: (ctx, i) {
                    final log = _grouped[i];
                    final showHeader = i == 0 || !_grouped[i - 1].date.startsWith(log.date.split(' ').first);
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if (showHeader)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8, top: i > 0 ? 12.0 : 0.0),
                          child: Text(
                            log.date.contains('Today') ? 'Today' : log.date.contains('Yesterday') ? 'Yesterday' : log.date.split(' ').take(3).join(' '),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
                          ),
                        ),
                      _buildLogCard(log, isDark),
                    ]);
                  },
                ),
        ),
      ]),
    );
  }

  Widget _buildLogCard(_LogEntry log, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: log.color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(log.icon, color: log.color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(log.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
          ]),
          const SizedBox(height: 3),
          Row(children: [
            const Icon(Icons.person_outline, size: 11, color: AppColors.textSecondaryLight),
            const SizedBox(width: 4),
            Text(log.user, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
            const SizedBox(width: 10),
            StatusBadge(label: log.action, color: log.color),
          ]),
        ])),
        const SizedBox(width: 8),
        Text(log.time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
      ]),
    );
  }

  String get _timeFromDate {
    return '';
  }
}

class _LogEntry {
  final String user, description, action, date;
  final Color color;
  final IconData icon;
  _LogEntry(this.user, this.description, this.action, this.color, this.icon, this.date);
  String get time => date.contains(' ') ? date.split(' ').skip(date.contains('Jul') ? 3 : 1).join(' ') : date;
}
