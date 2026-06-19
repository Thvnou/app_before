import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/matching_logic.dart';
import '../models/group_model.dart';
import 'group_provider.dart';
import 'safety_provider.dart';
import 'swipe_provider.dart';

/// The swipeable feed: every active before in the same city, gender-filtered
/// against my own group, minus anything I already swiped, anything reported
/// into suspension, and anything involving a blocked member.
final feedProvider = Provider<List<BeforeGroup>>((ref) {
  final all = ref.watch(allGroupsProvider);
  final myGroup = ref.watch(myGroupProvider);
  final swipedIds = ref.watch(swipeProvider);
  final blockedUserIds = ref.watch(safetyProvider).blockedUserIds;

  return all.where((g) {
    if (myGroup != null && g.id == myGroup.id) return false;
    if (!g.actif || g.isSuspended) return false;
    if (myGroup != null && g.ville != myGroup.ville) return false;
    if (swipedIds.contains(g.id)) return false;
    if (g.membres.any((m) => blockedUserIds.contains(m.id))) return false;
    if (myGroup != null && !genderCompatible(myGroup, g)) return false;
    return true;
  }).toList();
});
