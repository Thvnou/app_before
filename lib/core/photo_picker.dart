import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'theme.dart';

/// Shows a camera/gallery bottom sheet and returns the picked image bytes,
/// or null if cancelled. Used for both the profile photo and group photo.
Future<Uint8List?> pickPhotoFromSheet(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: BizzColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(BizzRadius.card)),
    ),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined, color: BizzColors.primary),
            title: const Text('Prendre une photo', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: BizzColors.primary),
            title: const Text('Choisir dans la galerie', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null) return null;

  try {
    final picked = await ImagePicker().pickImage(source: source, maxWidth: 800, imageQuality: 80);
    if (picked == null) return null;
    return picked.readAsBytes();
  } catch (_) {
    return null;
  }
}
