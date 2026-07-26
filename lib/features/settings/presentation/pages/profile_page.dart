import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('settings.profile'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: Stack(children: [
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Text('A', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w700)),
            ),
            Positioned(bottom: 0, right: 0, child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 14),
            )),
          ])),
          const SizedBox(height: 24),
          _buildField(context, 'First Name', 'Ahmed', isDark),
          _buildField(context, 'Last Name', 'Al-Rashidi', isDark),
          _buildField(context, 'Email', 'admin@restaurant.com', isDark),
          _buildField(context, 'Phone', '+966 50 123 4567', isDark),
          _buildField(context, 'Role', 'Owner', isDark, readOnly: true),
          _buildField(context, 'Branch', 'Main Branch — Riyadh', isDark, readOnly: true),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {}, child: Text('common.save'.tr())),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, String label, String value, bool isDark, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: readOnly ? null : const Icon(Icons.edit_outlined, size: 16),
        ),
      ),
    );
  }
}
