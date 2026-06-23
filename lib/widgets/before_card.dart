import 'package:flutter/material.dart';

import '../core/format_utils.dart';
import '../core/theme.dart';
import '../models/enums.dart';
import '../models/group_model.dart';
import 'avatar_stack.dart';

/// The "before" post card: who's going, where, and who they're hoping to
/// meet. Used both in the swipe feed and on the profile tab.
class BeforeCard extends StatelessWidget {
  final BeforeGroup group;
  final VoidCallback? onReport;

  const BeforeCard({super.key, required this.group, this.onReport});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BizzRadius.card),
        border: Border.all(color: BizzColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [BizzColors.surfaceVariant, BizzColors.surface],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 68, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                AvatarStack(membres: group.membres, radius: 28),
                const SizedBox(height: 14),
                Text(
                  group.nom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${group.tailleGroupe} ${group.tailleGroupe > 1 ? 'personnes' : 'personne'} • ${group.agesLabel} ans',
                  style: const TextStyle(color: BizzColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: BizzColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        group.club,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (group.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    group.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: BizzColors.textSecondary,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
                const Spacer(),
                if (group.ambiance.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final a in group.ambiance)
                        Chip(
                          label: Text(a.label),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _Badge(text: group.genreRecherche.label, background: BizzColors.primary),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: _Badge(
              text: 'Ce soir ${formatHeure(group.heureSortie)}',
              background: BizzColors.surfaceVariant,
            ),
          ),
          if (onReport != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.white70),
                onPressed: onReport,
                tooltip: 'Options',
              ),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color background;

  const _Badge({required this.text, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(BizzRadius.chip),
        border: Border.all(color: Colors.black26),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
