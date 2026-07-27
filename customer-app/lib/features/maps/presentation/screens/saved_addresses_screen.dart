import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});
  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final _addresses = [
    _Addr('Home', Icons.home_outlined, 'Al Olaya, Block 5, Villa 12, Riyadh', true),
    _Addr('Work', Icons.work_outline, 'King Fahd Road, Al Faisaliah Tower, Floor 8', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final addr in _addresses) _AddressCard(
            addr: addr,
            onDelete: () => setState(() => _addresses.remove(addr)),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push(RouteNames.mapPicker),
            icon: const Icon(Icons.add_location_alt_outlined),
            label: const Text('Add New Address'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final _Addr addr;
  final VoidCallback onDelete;
  const _AddressCard({required this.addr, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: addr.isDefault ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
          child: Icon(addr.icon, color: addr.isDefault ? AppColors.primary : Colors.grey),
        ),
        title: Row(children: [
          Text(addr.label, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (addr.isDefault) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text('Default', style: TextStyle(color: AppColors.primary, fontSize: 10)),
            ),
          ],
        ]),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(addr.address, style: const TextStyle(fontSize: 12)),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) { if (v == 'delete') onDelete(); },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'default', child: Text('Set as default')),
            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _Addr {
  final String label, address;
  final IconData icon;
  final bool isDefault;
  const _Addr(this.label, this.icon, this.address, this.isDefault);
}
