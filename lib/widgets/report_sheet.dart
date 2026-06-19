import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../models/enums.dart';
import '../models/group_model.dart';
import '../providers/safety_provider.dart';

/// "..." menu on a before card: report the group, or block one of its
/// members. Phase 5 front-end behaviour — three reports suspend a group
/// from the feed (see [BeforeGroup.isSuspended]).
Future<void> showReportSheet(BuildContext context, WidgetRef ref, BeforeGroup group) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: BizzColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(BizzRadius.card)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Signaler "${group.nom}"',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pourquoi signalez-vous ce groupe ?',
                style: TextStyle(color: BizzColors.textSecondary),
              ),
              const SizedBox(height: 12),
              for (final motif in ReportMotif.values)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.flag_outlined, color: BizzColors.primary),
                  title: Text(motif.label, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    final reported = ref.read(safetyProvider.notifier).reportGroup(group.id, motif);
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          reported
                              ? 'Signalement envoye, merci.'
                              : 'Vous avez deja signale ce groupe.',
                        ),
                      ),
                    );
                  },
                ),
              const Divider(height: 24),
              TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
