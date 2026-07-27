import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class TodaysTasksPage extends StatefulWidget {
  const TodaysTasksPage({super.key});
  @override
  State<TodaysTasksPage> createState() => _TodaysTasksPageState();
}

class _TodaysTasksPageState extends State<TodaysTasksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

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

  final List<_Task> _opening = [
    _Task('Turn on all kitchen equipment', 'Kitchen', 'Hassan Ali', true, AppColors.kpiGreen),
    _Task('Check stock levels & flag shortages', 'Inventory', 'Noura Hassan', true, AppColors.kpiGreen),
    _Task('Inspect table setup & cleanliness', 'Front of House', 'Ahmed Mohammed', true, AppColors.kpiGreen),
    _Task('Enable POS system & verify float', 'Cashier', 'Sara Khalid', true, AppColors.kpiGreen),
    _Task('Review daily specials & briefing', 'Management', null, false, AppColors.kpiBlue),
    _Task('Confirm reservations for today', 'Front of House', null, false, AppColors.kpiBlue),
  ];

  final List<_Task> _ongoing = [
    _Task('Monitor food quality — grill station', 'Kitchen', 'Omar Nasser', false, AppColors.warning),
    _Task('Refill napkins & condiments every 2 hours', 'Front of House', 'Ahmed Mohammed', true, AppColors.kpiGreen),
    _Task('Verify delivery orders before dispatch', 'Delivery', 'Khalid Abdullah', false, AppColors.warning),
    _Task('Update waste log by shift', 'Inventory', 'Noura Hassan', false, AppColors.warning),
    _Task('Check walk-in fridge temperatures', 'Kitchen', 'Hassan Ali', true, AppColors.kpiGreen),
  ];

  final List<_Task> _closing = [
    _Task('Reconcile cash register & POS totals', 'Cashier', null, false, AppColors.kpiBlue),
    _Task('Deep clean all kitchen surfaces', 'Kitchen', null, false, AppColors.kpiBlue),
    _Task('Log end-of-day waste report', 'Inventory', null, false, AppColors.kpiBlue),
    _Task('Lock storage & secure valuables', 'Management', null, false, AppColors.kpiBlue),
    _Task('Submit daily sales summary', 'Management', null, false, AppColors.kpiBlue),
  ];

  List<_Task> get _current {
    if (_tab.index == 0) return _opening;
    if (_tab.index == 1) return _ongoing;
    return _closing;
  }

  int _completedOf(List<_Task> tasks) => tasks.where((t) => t.done).length;

  void _toggleTask(List<_Task> list, int i) {
    setState(() {
      list[i] = _Task(list[i].title, list[i].department, list[i].assignee,
          !list[i].done, list[i].color);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final openDone = _completedOf(_opening);
    final onDone = _completedOf(_ongoing);
    final closeDone = _completedOf(_closing);
    final totalDone = openDone + onDone + closeDone;
    final totalAll = _opening.length + _ongoing.length + _closing.length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('todays_tasks.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.add_task_outlined), onPressed: () => _showAddSheet(context)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            onTap: (_) => setState(() {}),
            tabs: [
              Tab(text: 'Opening ($openDone/${_opening.length})'),
              Tab(text: 'Ongoing ($onDone/${_ongoing.length})'),
              Tab(text: 'Closing ($closeDone/${_closing.length})'),
            ],
          ),
        ),
      ),
      body: Column(children: [
        // Overall progress bar
        Container(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.task_alt_outlined, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text('Daily Progress: $totalDone / $totalAll tasks',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${(totalDone / totalAll * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: totalDone / totalAll,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 8,
              ),
            ),
          ]),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildTaskList(_opening, isDark),
              _buildTaskList(_ongoing, isDark),
              _buildTaskList(_closing, isDark),
            ],
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('todays_tasks.add'.tr(), style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildTaskList(List<_Task> tasks, bool isDark) {
    final done = _completedOf(tasks);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Section progress
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Row(children: [
            Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: 48, height: 48,
                child: CircularProgressIndicator(
                  value: done / tasks.length,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  color: done == tasks.length ? AppColors.kpiGreen : AppColors.primary,
                  strokeWidth: 4,
                ),
              ),
              Text('$done', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ]),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$done of ${tasks.length} completed',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              Text('${tasks.length - done} tasks remaining',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
            ]),
          ]),
        ),
        // Task cards
        ...tasks.asMap().entries.map((e) {
          final task = e.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: task.done
                    ? AppColors.kpiGreen.withOpacity(0.4)
                    : isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              leading: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.done,
                  onChanged: (_) => _toggleTask(tasks, e.key),
                  activeColor: AppColors.kpiGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  decoration: task.done ? TextDecoration.lineThrough : null,
                  color: task.done ? AppColors.textSecondaryLight : null,
                ),
              ),
              subtitle: Row(children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: task.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(task.department,
                      style: TextStyle(fontSize: 10, color: task.color, fontWeight: FontWeight.w600)),
                ),
                if (task.assignee != null) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.person_outline, size: 11, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 3),
                  Text(task.assignee!,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                ],
              ]),
              trailing: task.done
                  ? const Icon(Icons.check_circle, color: AppColors.kpiGreen, size: 18)
                  : const Icon(Icons.radio_button_unchecked, color: AppColors.textSecondaryLight, size: 18),
            ),
          );
        }),
      ],
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('todays_tasks.add'.tr(), style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Task Description', prefixIcon: Icon(Icons.task_outlined))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Department', prefixIcon: Icon(Icons.business_outlined))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Assign To (optional)', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: Text('common.save'.tr()))),
        ]),
      ),
    );
  }
}

class _Task {
  final String title, department;
  final String? assignee;
  final bool done;
  final Color color;
  _Task(this.title, this.department, this.assignee, this.done, this.color);
}
