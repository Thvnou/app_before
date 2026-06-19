import 'package:flutter/material.dart';

import '../core/constants.dart';

/// Tappable suggestions shown when a chat has no messages yet, so the
/// first message is one tap away.
class QuickReplyBar extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const QuickReplyBar({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: BizzConstants.quickReplies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final text = BizzConstants.quickReplies[index];
          return ActionChip(
            label: Text(text),
            onPressed: () => onSelect(text),
          );
        },
      ),
    );
  }
}
