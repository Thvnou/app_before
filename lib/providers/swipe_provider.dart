import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/matching_logic.dart';
import '../models/enums.dart';
import '../models/group_model.dart';
import '../models/match_model.dart';
import 'group_provider.dart';
import 'match_provider.dart';

/// Ids of every other group my group has already swiped on this session,
/// used to keep the feed from re-showing them.
class SwipeNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  /// Records the swipe and, on a mutual right-swipe, creates a match.
  /// Returns the new match, or null if there isn't one.
  BeforeMatch? swipe(BeforeGroup other, SwipeDirection direction) {
    state = {...state, other.id};

    if (direction == SwipeDirection.left) return null;

    final myGroup = ref.read(myGroupProvider);
    if (myGroup == null) return null;

    // No real second user to swipe back — seed groups flagged autoLikesBack
    // simulate the "they already liked you too" half of the symmetric match.
    if (!other.autoLikesBack) return null;
    if (!genderCompatible(myGroup, other) || !genderCompatible(other, myGroup)) {
      return null;
    }

    return ref.read(matchProvider.notifier).createMatch(myGroup, other);
  }
}

final swipeProvider = NotifierProvider<SwipeNotifier, Set<String>>(SwipeNotifier.new);
