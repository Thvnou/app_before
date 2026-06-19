import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme.dart';
import '../providers/chat_provider.dart';

/// Bottom-nav chrome wrapping the three main tabs (Swipe / Matchs / Profil).
class AppShell extends ConsumerWidget {
  final Widget child;
  final int currentIndex;

  const AppShell({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnread = ref.watch(totalUnreadProvider) > 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/swipe');
            case 1:
              context.go('/matches');
            case 2:
              context.go('/profile');
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_outlined),
            activeIcon: Icon(Icons.local_fire_department),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(icon: Icons.chat_bubble_outline, showBadge: hasUnread),
            activeIcon: _NavIcon(icon: Icons.chat_bubble, showBadge: hasUnread),
            label: 'Matchs',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool showBadge;

  const _NavIcon({required this.icon, required this.showBadge});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (showBadge)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(color: BizzColors.primary, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }
}
