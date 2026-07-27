import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _tickets = [
    _Ticket('T-001', 'Late payment not received', 'open', '26 Jul'),
    _Ticket('T-002', 'Customer complaint about delivery', 'resolved', '20 Jul'),
    _Ticket('T-003', 'Map navigation issue', 'resolved', '15 Jul'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        actions: [
          IconButton(onPressed: () => _newTicket(context), icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick actions
          Row(children: [
            _QuickAction(Icons.help_outline, 'FAQ', () {}),
            const SizedBox(width: 10),
            _QuickAction(Icons.phone_outlined, 'Call Support', () {}),
            const SizedBox(width: 10),
            _QuickAction(Icons.chat_outlined, 'Live Chat', () => context.push('/support/chat/live')),
          ]),
          const SizedBox(height: 20),

          const Text('My Tickets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),

          if (_tickets.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No support tickets', style: TextStyle(color: Colors.grey)),
            ))
          else
            for (final t in _tickets)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (t.status == 'open' ? AppColors.warning : AppColors.success).withOpacity(0.1),
                    child: Icon(t.status == 'open' ? Icons.pending_outlined : Icons.check_circle_outline,
                        color: t.status == 'open' ? AppColors.warning : AppColors.success),
                  ),
                  title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text('${t.id} · ${t.date}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (t.status == 'open' ? AppColors.warning : AppColors.success).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(t.status, style: TextStyle(fontSize: 11, color: t.status == 'open' ? AppColors.warning : AppColors.success, fontWeight: FontWeight.w600)),
                  ),
                  onTap: () => context.push('/support/chat/${t.id}'),
                ),
              ),
        ],
      ),
    );
  }

  void _newTicket(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('New Support Ticket', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(labelText: 'Subject', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        const TextField(decoration: InputDecoration(labelText: 'Describe your issue', border: OutlineInputBorder()), maxLines: 3),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          child: const Text('Submit Ticket'),
        ),
      ]),
    ));
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => Expanded(child: Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
        ]),
      ),
    ),
  ));
}

class _Ticket {
  final String id, title, status, date;
  const _Ticket(this.id, this.title, this.status, this.date);
}
