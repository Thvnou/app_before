import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/match_model.dart';
import 'avatar_stack.dart';
import 'primary_button.dart';

/// Full-screen "it's a match!" celebration, shown right after a mutual
/// right-swipe creates a [BeforeMatch].
Future<void> showMatchOverlay(
  BuildContext context, {
  required BeforeMatch match,
  required VoidCallback onSendMessage,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'match',
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (ctx, anim1, anim2) {
      return _MatchOverlayContent(match: match, onSendMessage: onSendMessage);
    },
    transitionBuilder: (ctx, anim, _, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.elasticOut),
        child: FadeTransition(opacity: anim, child: child),
      );
    },
  );
}

class _MatchOverlayContent extends StatelessWidget {
  final BeforeMatch match;
  final VoidCallback onSendMessage;

  const _MatchOverlayContent({required this.match, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'BIZZ !',
              style: TextStyle(
                color: BizzColors.primary,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "C'est un match !",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              '${match.myGroup.nom} et ${match.otherGroup.nom} vont passer la soiree ensemble. Organisez votre before !',
              textAlign: TextAlign.center,
              style: const TextStyle(color: BizzColors.textSecondary),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarStack(membres: match.myGroup.membres, radius: 34),
                const SizedBox(width: 12),
                const Icon(Icons.favorite, color: BizzColors.primary, size: 28),
                const SizedBox(width: 12),
                AvatarStack(membres: match.otherGroup.membres, radius: 34),
              ],
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Envoyer un message',
                icon: Icons.chat_bubble_outline,
                onPressed: () {
                  Navigator.of(context).pop();
                  onSendMessage();
                },
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continuer a swiper', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}
