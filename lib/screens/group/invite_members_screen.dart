import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/mock_seed.dart';
import '../../providers/group_provider.dart';
import '../../widgets/bizz_avatar.dart';
import '../../widgets/primary_button.dart';

class InviteMembersScreen extends ConsumerWidget {
  const InviteMembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(myGroupProvider);

    if (group == null) {
      return const Scaffold(body: Center(child: Text('Cree ton before pour inviter du monde')));
    }

    final inviteLink = 'https://bizz.app/invite/${group.id}';
    final canAddMore = group.membres.length < BizzConstants.groupMaxMembers;

    return Scaffold(
      appBar: AppBar(title: const Text('Inviter des amis')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              '${group.membres.length} / ${BizzConstants.groupMaxMembers} membres',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Partage ce lien, des qu un ami clique dessus il rejoint le groupe.',
              style: TextStyle(color: BizzColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BizzColors.surface,
                borderRadius: BorderRadius.circular(BizzRadius.button),
                border: Border.all(color: BizzColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      inviteLink,
                      style: const TextStyle(color: BizzColors.textSecondary, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy, color: BizzColors.primary),
                    tooltip: 'Copier',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: inviteLink));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lien copie dans le presse-papiers')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Copier le lien d\'invitation',
              icon: Icons.link,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: inviteLink));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lien copie dans le presse-papiers')),
                );
              },
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Simuler un ami qui rejoint (demo)',
              icon: Icons.person_add_alt,
              outlined: true,
              onPressed: canAddMore
                  ? () => ref.read(myGroupProvider.notifier).addMember(MockSeed.randomFriend())
                  : null,
            ),
            const SizedBox(height: 28),
            const Text(
              'Membres du groupe',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final membre in group.membres)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    BizzAvatar.user(membre, radius: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${membre.prenom}, ${membre.age} ans',
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    if (membre.id == group.creePar)
                      const Text('Createur', style: TextStyle(color: BizzColors.textSecondary, fontSize: 12))
                    else
                      IconButton(
                        icon: const Icon(Icons.close, color: BizzColors.textSecondary, size: 18),
                        onPressed: () => ref.read(myGroupProvider.notifier).removeMember(membre.id),
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
