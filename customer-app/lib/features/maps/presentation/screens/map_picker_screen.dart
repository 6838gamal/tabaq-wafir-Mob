import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});
  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  String _selectedAddress = 'Al Olaya, Riyadh';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Column(children: [
        Expanded(
          child: Stack(children: [
            Container(
              color: Colors.grey.shade200,
              child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.map_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 8),
                Text('Interactive map', style: TextStyle(color: Colors.grey)),
                Text('(requires Google Maps API key)', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ])),
            ),
            // Center pin
            const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.location_pin, size: 48, color: Colors.red),
              SizedBox(height: 48),
            ])),
            // Search bar on top of map
            Positioned(
              top: 12, left: 12, right: 12,
              child: Card(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search for a location...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (v) => setState(() => _selectedAddress = v.isNotEmpty ? v : 'Al Olaya, Riyadh'),
                ),
              ),
            ),
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Selected Location', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(_selectedAddress, style: const TextStyle(fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_selectedAddress),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: const Text('Confirm Location'),
            ),
          ]),
        ),
      ]),
    );
  }
}
