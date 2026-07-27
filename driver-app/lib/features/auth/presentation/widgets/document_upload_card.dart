// lib/features/auth/presentation/widgets/document_upload_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';

class DocumentUploadCard extends StatelessWidget {
  final String documentType;
  final String? uploadedPath;
  final ValueChanged<String> onFileSelected;

  const DocumentUploadCard({
    super.key,
    required this.documentType,
    required this.uploadedPath,
    required this.onFileSelected,
  });

  String get _title {
    switch (documentType) {
      case 'driving_license':
        return 'Driving License';
      case 'vehicle_registration':
        return 'Vehicle Registration';
      case 'insurance':
        return 'Insurance Certificate';
      case 'profile_photo':
        return 'Profile Photo';
      default:
        return documentType.replaceAll('_', ' ').toUpperCase();
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) onFileSelected(image.path);
  }

  @override
  Widget build(BuildContext context) {
    final isUploaded = uploadedPath != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isUploaded
                ? AppColors.success.withOpacity(0.1)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: isUploaded
              ? Image.file(File(uploadedPath!), fit: BoxFit.cover)
              : const Icon(Icons.upload_file, color: AppColors.textSecondary),
        ),
        title: Text(_title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          isUploaded ? 'Uploaded ✓' : 'Tap to upload',
          style: TextStyle(
            color: isUploaded ? AppColors.success : AppColors.textSecondary,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isUploaded ? Icons.edit : Icons.add_circle_outline,
            color: AppColors.primary,
          ),
          onPressed: () => _pickImage(context),
        ),
      ),
    );
  }
}
