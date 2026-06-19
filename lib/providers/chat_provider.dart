import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/id_generator.dart';
import '../models/match_model.dart';
import '../models/message_model.dart';
import 'auth_provider.dart';

const _quickAutoReplies = [
  'Ca marche !',
  'Parfait, a toute a l\'heure',
  'Nickel, on y sera',
  'Avec plaisir !',
  'On valide, a ce soir',
  'Top, on se voit la-bas',
];

/// Messages keyed by matchId. There is no realtime backend, so a reply is
/// simulated shortly after you send a message — close enough to a live
/// stream for the UI to feel alive, without pretending it's a real person.
class ChatNotifier extends Notifier<Map<String, List<Message>>> {
  final _random = Random();

  @override
  Map<String, List<Message>> build() => {};

  List<Message> messagesFor(String matchId) => state[matchId] ?? [];

  void sendMessage({
    required BeforeMatch match,
    required String content,
  }) {
    final me = ref.read(authProvider).profile;
    if (me == null || content.trim().isEmpty) return;

    final message = Message(
      id: generateId('msg'),
      matchId: match.id,
      senderId: me.id,
      senderPrenom: me.prenom,
      isMe: true,
      contenu: content.trim(),
      lu: true,
      createdAt: DateTime.now(),
    );
    _append(match.id, message);

    if (match.otherGroup.membres.isEmpty) return;
    Future.delayed(Duration(milliseconds: 900 + _random.nextInt(900)), () {
      final replier = match.otherGroup.membres[
          _random.nextInt(match.otherGroup.membres.length)];
      final reply = Message(
        id: generateId('msg'),
        matchId: match.id,
        senderId: replier.id,
        senderPrenom: replier.prenom,
        isMe: false,
        contenu: _quickAutoReplies[_random.nextInt(_quickAutoReplies.length)],
        lu: false,
        createdAt: DateTime.now(),
      );
      _append(match.id, reply);
    });
  }

  void markAsRead(String matchId) {
    final current = state[matchId];
    if (current == null) return;
    state = {
      ...state,
      matchId: [for (final m in current) m.copyWith(lu: true)],
    };
  }

  int unreadCount(String matchId) {
    return (state[matchId] ?? []).where((m) => !m.isMe && !m.lu).length;
  }

  void _append(String matchId, Message message) {
    final current = state[matchId] ?? [];
    state = {...state, matchId: [...current, message]};
  }
}

final chatProvider = NotifierProvider<ChatNotifier, Map<String, List<Message>>>(
  ChatNotifier.new,
);

/// Sum of unread messages across every match — drives the bottom nav badge.
final totalUnreadProvider = Provider<int>((ref) {
  final chatState = ref.watch(chatProvider);
  var total = 0;
  for (final messages in chatState.values) {
    total += messages.where((m) => !m.isMe && !m.lu).length;
  }
  return total;
});
