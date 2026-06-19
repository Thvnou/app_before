import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/match_provider.dart';
import '../../providers/safety_provider.dart';
import '../../providers/swipe_provider.dart';
import '../../widgets/bizz_avatar.dart';
import '../../widgets/primary_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  List<AppUser> _blockedUsers(WidgetRef ref) {
    final blockedIds = ref.watch(safetyProvider).blockedUserIds;
    if (blockedIds.isEmpty) return [];
    final allGroups = ref.watch(allGroupsProvider);
    final found = <AppUser>[];
    for (final group in allGroups) {
      for (final member in group.membres) {
        if (blockedIds.contains(member.id) && !found.any((u) => u.id == member.id)) {
          found.add(member);
        }
      }
    }
    return found;
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).signOut();
    ref.read(myGroupProvider.notifier).clear();
    if (context.mounted) context.go('/login');
  }

  Future<void> _confirmDeleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BizzColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BizzRadius.card)),
        title: const Text('Supprimer ton compte ?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Ton profil, ton before, tes matchs et tes messages seront definitivement supprimes.',
          style: TextStyle(color: BizzColors.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer', style: TextStyle(color: BizzColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(authProvider.notifier).signOut();
    ref.read(myGroupProvider.notifier).clear();
    ref.invalidate(allGroupsProvider);
    ref.invalidate(matchProvider);
    ref.invalidate(chatProvider);
    ref.invalidate(swipeProvider);
    ref.invalidate(safetyProvider);

    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedUsers = _blockedUsers(ref);

    return Scaffold(
      appBar: AppBar(title: const Text('Parametres')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Utilisateurs bloques',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (blockedUsers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Aucun utilisateur bloque', style: TextStyle(color: BizzColors.textSecondary)),
            )
          else
            for (final user in blockedUsers)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: BizzAvatar.user(user, radius: 20),
                title: Text(user.prenom, style: const TextStyle(color: Colors.white)),
                trailing: TextButton(
                  onPressed: () => ref.read(safetyProvider.notifier).unblockUser(user.id),
                  child: const Text('Debloquer'),
                ),
              ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.privacy_tip_outlined, color: BizzColors.textSecondary),
            title: const Text('Politique de confidentialite', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: BizzColors.textSecondary),
            onTap: () => context.push('/privacy'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Se deconnecter',
            outlined: true,
            onPressed: () => _signOut(context, ref),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Supprimer mon compte',
            icon: Icons.delete_outline,
            onPressed: () => _confirmDeleteAccount(context, ref),
          ),
        ],
      ),
    );
  }
}
