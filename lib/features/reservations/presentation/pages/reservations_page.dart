import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});
  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  final _reservations = [
    _Reservation('Mohammed Al-Ghamdi', 4, 'Today 7:00 PM', 'Table 8', 'Confirmed', AppColors.success),
    _Reservation('Sara Al-Otaibi', 2, 'Today 7:30 PM', 'Table 3', 'Confirmed', AppColors.success),
    _Reservation('Khalid Rashidi', 6, 'Today 8:00 PM', 'Table 12', 'Pending', AppColors.warning),
    _Reservation('Aisha Noor', 3, 'Today 8:30 PM', 'Table 5', 'Confirmed', AppColors.success),
    _Reservation('Ahmed Qasim', 8, 'Today 9:00 PM', 'Table 14', 'Pending', AppColors.warning),
  ];

  final _waitlist = [
    _Reservation('Fatima Al-Hassan', 4, 'Waiting since 7:00 PM', '—', 'Waiting', AppColors.kpiOrange),
    _Reservation('Omar Abdullah', 2, 'Waiting since 7:15 PM', '—', 'Waiting', AppColors.kpiOrange),
  ];

  final _noShows = [
    _Reservation('Ali Mansour', 3, 'Today 6:00 PM', 'Table 7', 'No Show', AppColors.error),
    _Reservation('Noura Fahad', 2, 'Today 6:30 PM', 'Table 2', 'No Show', AppColors.error),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reservations.title'.tr()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(controller: _tab,
              tabs: ['Reservations (${_reservations.length})', 'Waitlist (${_waitlist.length})', 'No Shows']
                  .map((t) => Tab(text: t)).toList()),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildList(_reservations),
          _buildList(_waitlist),
          _buildList(_noShows),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('reservations.add_reservation'.tr(), style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildList(List<_Reservation> list) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (list.isEmpty) {
      return const EmptyState(icon: Icons.event_busy_outlined, title: 'No entries', subtitle: 'Nothing to show here.');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final r = list[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: r.statusColor.withOpacity(0.12),
              child: Text(r.name.substring(0, 1), style: TextStyle(fontWeight: FontWeight.w700, color: r.statusColor)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 3),
              Row(children: [
                const Icon(Icons.people_outline, size: 12, color: AppColors.textSecondaryLight),
                const SizedBox(width: 4),
                Text('${r.partySize} guests', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 10),
                const Icon(Icons.access_time, size: 12, color: AppColors.textSecondaryLight),
                const SizedBox(width: 4),
                Text(r.time, style: const TextStyle(fontSize: 12)),
              ]),
              const SizedBox(height: 3),
              Text(r.table, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              StatusBadge(label: r.status, color: r.statusColor),
              const SizedBox(height: 8),
              Row(children: [
                GestureDetector(onTap: () {}, child: const Icon(Icons.message_outlined, size: 16, color: AppColors.primary)),
                const SizedBox(width: 10),
                GestureDetector(onTap: () {}, child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary)),
              ]),
            ]),
          ]),
        );
      },
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('reservations.add_reservation'.tr(), style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Guest Name', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Party Size', prefixIcon: Icon(Icons.people_outline)), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Date & Time', prefixIcon: Icon(Icons.calendar_today_outlined))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: Text('common.save'.tr()))),
        ]),
      ),
    );
  }
}

class _Reservation {
  final String name, time, table, status; final int partySize; final Color statusColor;
  _Reservation(this.name, this.partySize, this.time, this.table, this.status, this.statusColor);
}
