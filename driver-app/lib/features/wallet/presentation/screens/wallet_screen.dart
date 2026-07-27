import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Balance card
          Card(
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                Icon(Icons.account_balance_wallet, color: Colors.white.withOpacity(0.8), size: 36),
                const SizedBox(height: 8),
                const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                const Text('635 SAR', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => _showWithdraw(context),
                    icon: const Icon(Icons.upload_outlined, color: Colors.white),
                    label: const Text('Withdraw', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white30)),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.history, color: Colors.white),
                    label: const Text('History', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white30)),
                  )),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // Quick stats
          Row(children: [
            _StatCard('Pending', '184 SAR', Icons.pending_outlined, Colors.orange),
            const SizedBox(width: 10),
            _StatCard('This Month', '4,840 SAR', Icons.calendar_today_outlined, AppColors.success),
            const SizedBox(width: 10),
            _StatCard('Total Earned', '24,600 SAR', Icons.trending_up, AppColors.primary),
          ]),
          const SizedBox(height: 20),

          // Transactions
          const Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(child: Column(children: [
            for (final t in [
              ('Delivery earnings', '+32 SAR', 'Today, 3:12 PM', true),
              ('Delivery earnings', '+28 SAR', 'Today, 1:45 PM', true),
              ('Withdrawal to bank', '-500 SAR', 'Yesterday, 10:00 AM', false),
              ('Delivery earnings', '+25 SAR', 'Yesterday, 8:30 PM', true),
              ('Bonus — weekend peak', '+50 SAR', '25 Jul', true),
            ]) ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: (t.$4 ? AppColors.success : Colors.red).withOpacity(0.1),
                child: Icon(t.$4 ? Icons.arrow_downward : Icons.arrow_upward, color: t.$4 ? AppColors.success : Colors.red, size: 18),
              ),
              title: Text(t.$1, style: const TextStyle(fontSize: 13)),
              subtitle: Text(t.$3, style: const TextStyle(fontSize: 11)),
              trailing: Text(t.$2, style: TextStyle(fontWeight: FontWeight.bold, color: t.$4 ? AppColors.success : Colors.red)),
            ),
          ])),
        ],
      ),
    );
  }

  void _showWithdraw(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Withdraw Funds', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(labelText: 'Amount (SAR)', border: OutlineInputBorder(), prefixText: 'SAR ')),
        const SizedBox(height: 12),
        const TextField(decoration: InputDecoration(labelText: 'Bank IBAN', border: OutlineInputBorder(), prefixIcon: Icon(Icons.account_balance_outlined))),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          child: const Text('Submit Withdrawal'),
        ),
      ]),
    ));
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Card(child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
    ]),
  )));
}
