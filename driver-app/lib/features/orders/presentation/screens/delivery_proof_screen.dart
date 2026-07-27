import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';

class DeliveryProofScreen extends StatefulWidget {
  final String orderId;
  const DeliveryProofScreen({super.key, required this.orderId});
  @override
  State<DeliveryProofScreen> createState() => _DeliveryProofScreenState();
}

class _DeliveryProofScreenState extends State<DeliveryProofScreen> {
  bool _photoTaken = false;
  bool _signed = false;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proof of Delivery')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Order #ORD-001', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text('Ahmed Al-Rashidi · Al Malqa District', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),

          // Photo proof
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('📸 Photo Proof', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              const Text('Take a photo of the delivered order.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              _photoTaken
                  ? Container(
                      height: 120,
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green)),
                      child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 32),
                        SizedBox(height: 4),
                        Text('Photo captured', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                      ])),
                    )
                  : OutlinedButton.icon(
                      onPressed: () => setState(() => _photoTaken = true),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Take Photo'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    ),
            ]),
          )),
          const SizedBox(height: 12),

          // Signature
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✍️ Customer Signature', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              const Text('Ask the customer to sign on your device.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              _signed
                  ? Container(
                      height: 80,
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green)),
                      child: const Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Signed', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                      ])),
                    )
                  : Container(
                      height: 120,
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid)),
                      child: InkWell(
                        onTap: () => setState(() => _signed = true),
                        child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.edit, color: Colors.grey),
                          SizedBox(height: 4),
                          Text('Tap to sign', style: TextStyle(color: Colors.grey)),
                        ])),
                      ),
                    ),
            ]),
          )),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: (_photoTaken && _signed && !_submitting) ? _submit : null,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            child: _submitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Submit & Complete Delivery', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.go(RouteNames.home);
  }
}
