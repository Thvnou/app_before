import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/format_utils.dart';
import '../../core/theme.dart';
import '../../models/match_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/match_provider.dart';
import '../../widgets/avatar_stack.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/quick_reply_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String matchId;

  const ChatScreen({super.key, required this.matchId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).markAsRead(widget.matchId);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _send(BeforeMatch match, [String? presetText]) {
    final text = presetText ?? _inputController.text;
    if (text.trim().isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(match: match, content: text);
    _inputController.clear();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _insertQuickReply(String text) {
    _inputController.text = text;
    _inputController.selection = TextSelection.collapsed(offset: text.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final matches = ref.watch(matchProvider);
    final candidates = matches.where((m) => m.id == widget.matchId);
    final match = candidates.isEmpty ? null : candidates.first;

    if (match == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Conversation introuvable', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final messages = ref.watch(chatProvider)[widget.matchId] ?? const [];

    ref.listen(chatProvider, (previous, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            AvatarStack(membres: match.otherGroup.membres, radius: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    match.otherGroup.nom,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${match.otherGroup.club} • ${formatHeure(match.otherGroup.heureSortie)}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: BizzColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: BizzColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(BizzRadius.button),
                border: Border.all(color: BizzColors.primary.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.celebration_outlined, color: BizzColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      match.beforeTermine
                          ? 'Ce before est termine'
                          : 'Vous avez matche ! Organisez votre before',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Dites bonjour a ${match.otherGroup.nom} !',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: BizzColors.textSecondary),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => ChatBubble(message: messages[index]),
                    ),
            ),
            if (messages.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: QuickReplyBar(onSelect: _insertQuickReply),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(color: Colors.white),
                      maxLength: BizzConstants.messageMaxLength,
                      decoration: const InputDecoration(
                        hintText: 'Ecrire un message...',
                        counterText: '',
                      ),
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _send(match),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _inputController.text.trim().isEmpty ? null : () => _send(match),
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: BizzColors.primary,
                      disabledBackgroundColor: BizzColors.surfaceVariant,
                    ),
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
