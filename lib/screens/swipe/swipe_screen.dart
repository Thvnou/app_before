import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/enums.dart';
import '../../models/group_model.dart';
import '../../providers/feed_provider.dart';
import '../../providers/swipe_provider.dart';
import '../../widgets/before_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/match_overlay.dart';
import '../../widgets/report_sheet.dart';
import '../../widgets/swipe_card_stack.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> {
  final _stackController = SwipeCardStackController();

  void _handleSwiped(BeforeGroup group, SwipeDirection direction) {
    final match = ref.read(swipeProvider.notifier).swipe(group, direction);
    if (match != null) {
      showMatchOverlay(
        context,
        match: match,
        onSendMessage: () => context.push('/chat/${match.id}'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Bizz',
          style: TextStyle(color: BizzColors.primary, fontWeight: FontWeight.w900, fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: feed.isEmpty
                  ? const EmptyState(
                      icon: Icons.nightlife_outlined,
                      title: 'Plus de befores ce soir',
                      subtitle: 'Revenez demain, ou creez le votre depuis l\'onglet Profil !',
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: SwipeCardStack(
                        cards: feed,
                        controller: _stackController,
                        cardBuilder: (ctx, group) => BeforeCard(
                          group: group,
                          onReport: () => showReportSheet(ctx, ref, group),
                        ),
                        onSwiped: _handleSwiped,
                      ),
                    ),
            ),
            if (feed.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 24, top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: Icons.close_rounded,
                      color: BizzColors.nope,
                      onTap: () => _stackController.swipeLeft(),
                    ),
                    const SizedBox(width: 28),
                    _ActionButton(
                      icon: Icons.favorite_rounded,
                      color: BizzColors.primary,
                      big: true,
                      onTap: () => _stackController.swipeRight(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool big;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = big ? 68.0 : 56.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: BizzColors.surface,
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 12, spreadRadius: 1),
          ],
        ),
        child: Icon(icon, color: color, size: big ? 32 : 26),
      ),
    );
  }
}
