import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});
  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  final _customers = [
    _Customer('Mohammed Al-Ghamdi', '+966501234567', 'VIP', 48, 'SAR 12,400', '2 days ago', AppColors.kpiPurple, 4.9),
    _Customer('Sara Al-Otaibi', '+966512345678', 'Regular', 22, 'SAR 5,800', '1 week ago', AppColors.kpiBlue, 4.7),
    _Customer('Khalid Rashidi', '+966523456789', 'Regular', 15, 'SAR 3,200', '3 days ago', AppColors.kpiGreen, 4.5),
    _Customer('Aisha Noor', '+966534567890', 'VIP', 61, 'SAR 18,900', 'Today', AppColors.kpiPurple, 5.0),
    _Customer('Ahmed Qasim', '+966545678901', 'New', 2, 'SAR 320', '1 day ago', AppColors.kpiOrange, 4.0),
    _Customer('Fatima Hassan', '+966556789012', 'Regular', 8, 'SAR 1,600', '2 weeks ago', AppColors.kpiTeal, 4.3),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('customers.title'.tr()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(controller: _tab,
              tabs: ['All', 'VIP', 'Reviews & Complaints'].map((t) => Tab(text: t)).toList()),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: AppSearchBar(hintText: 'Search customers...', onFilterTap: () {}),
          ),
          Expanded(child: TabBarView(controller: _tab, children: [
            _buildCustomerList(_customers, isDark),
            _buildCustomerList(_customers.where((c) => c.tier == 'VIP').toList(), isDark),
            _buildReviewsTab(isDark),
          ])),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildCustomerList(List<_Customer> list, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final c = list[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: c.color.withOpacity(0.12),
              child: Text(c.name.substring(0, 1), style: TextStyle(fontWeight: FontWeight.w700, color: c.color, fontSize: 16)),
            ),
            title: Row(children: [
              Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(width: 8),
              StatusBadge(label: c.tier, color: c.tier == 'VIP' ? AppColors.kpiPurple : c.tier == 'New' ? AppColors.kpiOrange : AppColors.kpiBlue),
            ]),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 4),
              Text('${c.visits} visits · ${c.totalSpent}', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.star, size: 12, color: AppColors.kpiOrange),
                const SizedBox(width: 2),
                Text(c.rating.toString(), style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 8),
                Text('Last visit: ${c.lastVisit}', style: TextStyle(fontSize: 11,
                    color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
              ]),
            ]),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right, size: 18),
              onPressed: () => _showCustomerDetail(context, c),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(bool isDark) {
    final reviews = [
      _Review('Mohammed A.', 5, 'Amazing food and service! Will definitely be back.', '2 days ago', false),
      _Review('Anonymous', 2, 'Food was cold and the waiter was rude.', '1 week ago', true),
      _Review('Sara O.', 4, 'Great atmosphere, slightly slow service tonight.', '3 days ago', false),
      _Review('Khalid R.', 5, 'Best restaurant in the city. The saffron rice is unreal!', '1 week ago', false),
      _Review('Anonymous', 1, 'Waited 1 hour for food. Very disappointing.', '2 weeks ago', true),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (ctx, i) {
        final r = reviews[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: r.isComplaint ? AppColors.error.withOpacity(0.3) : (isDark ? AppColors.borderDark : AppColors.borderLight)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 14, backgroundColor: AppColors.kpiBlue.withOpacity(0.12),
                child: Text(r.name.substring(0, 1), style: const TextStyle(fontSize: 12, color: AppColors.kpiBlue, fontWeight: FontWeight.w700))),
              const SizedBox(width: 10),
              Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              Row(children: List.generate(5, (s) => Icon(Icons.star, size: 14,
                  color: s < r.stars ? AppColors.kpiOrange : (isDark ? AppColors.borderDark : AppColors.borderLight)))),
            ]),
            const SizedBox(height: 8),
            Text(r.text, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            Row(children: [
              Text(r.time, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
              const Spacer(),
              if (r.isComplaint) StatusBadge(label: 'Complaint', color: AppColors.error),
              const SizedBox(width: 8),
              TextButton(onPressed: () {}, child: const Text('Reply', style: TextStyle(fontSize: 12))),
            ]),
          ]),
        );
      },
    );
  }

  void _showCustomerDetail(BuildContext context, _Customer c) {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.6, expand: false,
      builder: (_, sc) => ListView(controller: sc, padding: const EdgeInsets.all(24), children: [
        Row(children: [
          CircleAvatar(radius: 32, backgroundColor: c.color.withOpacity(0.12),
            child: Text(c.name.substring(0, 1), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: c.color))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.name, style: Theme.of(ctx).textTheme.titleLarge),
            StatusBadge(label: c.tier, color: c.tier == 'VIP' ? AppColors.kpiPurple : AppColors.kpiBlue),
          ])),
        ]),
        const SizedBox(height: 24),
        Row(children: [
          _statBox('Total Visits', c.visits.toString(), AppColors.kpiBlue),
          const SizedBox(width: 12),
          _statBox('Total Spent', c.totalSpent, AppColors.kpiGreen),
          const SizedBox(width: 12),
          _statBox('Rating', c.rating.toString(), AppColors.kpiOrange),
        ]),
      ]),
    ));
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
      ]),
    ));
  }
}

class _Customer {
  final String name, phone, tier, totalSpent, lastVisit; final int visits; final Color color; final double rating;
  _Customer(this.name, this.phone, this.tier, this.visits, this.totalSpent, this.lastVisit, this.color, this.rating);
}

class _Review {
  final String name, text, time; final int stars; final bool isComplaint;
  _Review(this.name, this.stars, this.text, this.time, this.isComplaint);
}
