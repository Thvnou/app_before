import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/theme.dart';
import '../../models/match_model.dart';
import '../../models/message_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/match_provider.dart';
import '../../widgets/bizz_avatar.dart';
import '../../widgets/empty_state.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(matchProvider);
    final chatState = ref.watch(chatProvider);

    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Matchs')),
        body: const EmptyState(
          icon: Icons.favorite_border,
          title: 'Pas encore de match',
          subtitle: 'Continuez a swiper pour trouver votre before !',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Matchs')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Nouveaux matchs',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: matches.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final match = matches[index];
                return GestureDetector(
                  onTap: () => context.push('/chat/${match.id}'),
                  child: SizedBox(
                    width: 68,
                    child: Column(
                      children: [
                        BizzAvatar.user(
                          match.otherGroup.membres.first,
                          radius: 30,
                          borderColor: BizzColors.primary,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          match.otherGroup.nom,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'En cours',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          for (final match in matches)
            _ConversationTile(match: match, messages: chatState[match.id] ?? const []),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final BeforeMatch match;
  final List<Message> messages;

  const _ConversationTile({required this.match, required this.messages});

  @override
  Widget build(BuildContext context) {
    final lastMessage = messages.isNotEmpty ? messages.last : null;
    final unread = messages.where((m) => !m.isMe && !m.lu).length;

    return ListTile(
      onTap: () => context.push('/chat/${match.id}'),
      leading: BizzAvatar.user(match.otherGroup.membres.first, radius: 26),
      title: Text(
        match.otherGroup.nom,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        lastMessage != null ? lastMessage.contenu : 'Vous avez matche, dites bonjour !',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: unread > 0 ? Colors.white : BizzColors.textSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastMessage != null ? timeago.format(lastMessage.createdAt, locale: 'fr') : '',
            style: const TextStyle(color: BizzColors.textSecondary, fontSize: 11),
          ),
          if (unread > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: BizzColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$unread',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
