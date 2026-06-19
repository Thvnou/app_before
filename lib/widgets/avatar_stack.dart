import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/user_model.dart';
import 'bizz_avatar.dart';

/// Overlapping member avatars ("2-4 avatars superposes") used on the
/// before card and group headers.
class AvatarStack extends StatelessWidget {
  final List<AppUser> membres;
  final double radius;

  const AvatarStack({super.key, required this.membres, this.radius = 26});

  @override
  Widget build(BuildContext context) {
    final shown = membres.take(4).toList();
    final extra = membres.length - shown.length;
    final step = radius * 0.8;
    final slots = shown.length + (extra > 0 ? 1 : 0);
    final width = slots == 0 ? 0.0 : radius * 2 + step * (slots - 1);

    return SizedBox(
      height: radius * 2,
      width: width,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: step * i,
              child: BizzAvatar.user(shown[i], radius: radius, borderColor: BizzColors.surface),
            ),
          if (extra > 0)
            Positioned(
              left: step * shown.length,
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BizzColors.surfaceVariant,
                  border: Border.all(color: BizzColors.surface, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$extra',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
