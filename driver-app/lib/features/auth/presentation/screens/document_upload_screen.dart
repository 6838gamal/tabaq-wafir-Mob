// lib/features/auth/presentation/screens/document_upload_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/document_upload_card.dart';

class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  final Map<String, String?> _uploadedPaths = {};
  bool _isUploading = false;

  void _onFileSelected(String docType, String filePath) {
    setState(() => _uploadedPaths[docType] = filePath);
  }

  bool get _allUploaded =>
      AppConstants.documentTypes.every((t) => _uploadedPaths.containsKey(t));

  Future<void> _submitDocuments() async {
    setState(() => _isUploading = true);
    try {
      final notifier = ref.read(authNotifierProvider.notifier);
      for (final entry in _uploadedPaths.entries) {
        if (entry.value != null) {
          await notifier.uploadDocument(
            documentType: entry.key,
            filePath: entry.value!,
          );
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documents submitted for review!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Documents')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (final docType in AppConstants.documentTypes)
                    DocumentUploadCard(
                      documentType: docType,
                      uploadedPath: _uploadedPaths[docType],
                      onFileSelected: (path) => _onFileSelected(docType, path),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Submit Documents',
              isLoading: _isUploading,
              onPressed: _allUploaded ? _submitDocuments : null,
            ),
          ],
        ),
      ),
    );
  }
}
