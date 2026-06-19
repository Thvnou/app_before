import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/user_model.dart';

/// Renders a user's photo regardless of where it came from: a locally
/// picked image (bytes, never persisted), a seed network URL, or neither
/// (initials fallback).
class BizzAvatar extends StatelessWidget {
  final String? photoUrl;
  final Uint8List? photoBytes;
  final String fallbackText;
  final double radius;
  final Color? borderColor;

  const BizzAvatar({
    super.key,
    this.photoUrl,
    this.photoBytes,
    required this.fallbackText,
    this.radius = 24,
    this.borderColor,
  });

  factory BizzAvatar.user(AppUser user, {double radius = 24, Color? borderColor}) {
    return BizzAvatar(
      photoUrl: user.photoUrl,
      photoBytes: user.photoBytes,
      fallbackText: user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '?',
      radius: radius,
      borderColor: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _content();
    if (borderColor == null) return content;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: borderColor!, width: 2)),
      child: content,
    );
  }

  Widget _content() {
    final size = radius * 2;
    if (photoBytes != null) {
      return ClipOval(
        child: Image.memory(photoBytes!, width: size, height: size, fit: BoxFit.cover),
      );
    }
    final url = photoUrl;
    if (url != null && url.startsWith('http')) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, _) => _fallback(),
          errorWidget: (_, _, _) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: BizzColors.primary.withValues(alpha: 0.85),
      child: Text(
        fallbackText,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}
