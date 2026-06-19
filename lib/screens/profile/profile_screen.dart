import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/enums.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';
import '../../widgets/before_card.dart';
import '../../widgets/bizz_avatar.dart';
import '../../widgets/primary_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(authProvider).profile;
    // The router guarantees a profile and a group exist before this screen
    // is reachable (see redirect logic in router.dart).
    final myGroup = ref.watch(myGroupProvider);
    if (me == null || myGroup == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                BizzAvatar.user(me, radius: 50),
                const SizedBox(height: 12),
                Text(
                  '${me.prenom}, ${me.age}',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${me.genre.label} • ${me.ville}',
                  style: const TextStyle(color: BizzColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mon before',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              TextButton.icon(
                onPressed: () => context.push('/edit-group'),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Modifier'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(height: 360, child: BeforeCard(group: myGroup)),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Inviter des amis',
            icon: Icons.person_add_alt,
            outlined: true,
            onPressed: () => context.push('/invite-members'),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.shield_outlined, color: BizzColors.textSecondary),
            title: const Text('Securite et confidentialite', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: BizzColors.textSecondary),
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }
}
