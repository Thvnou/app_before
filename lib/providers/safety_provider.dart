import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import 'group_provider.dart';

class SafetyState {
  final Set<String> blockedUserIds;
  final Set<String> reportedGroupIds;

  const SafetyState({
    this.blockedUserIds = const {},
    this.reportedGroupIds = const {},
  });

  SafetyState copyWith({
    Set<String>? blockedUserIds,
    Set<String>? reportedGroupIds,
  }) {
    return SafetyState(
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      reportedGroupIds: reportedGroupIds ?? this.reportedGroupIds,
    );
  }
}

/// Front-end-only stand-in for Phase 5 (reports, blocks). Reports increment
/// a group's reportCount via [AllGroupsNotifier]; three reports suspends it
/// from the feed (see [BeforeGroup.isSuspended]).
class SafetyNotifier extends Notifier<SafetyState> {
  @override
  SafetyState build() => const SafetyState();

  void blockUser(String userId) {
    state = state.copyWith(blockedUserIds: {...state.blockedUserIds, userId});
  }

  void unblockUser(String userId) {
    final updated = {...state.blockedUserIds}..remove(userId);
    state = state.copyWith(blockedUserIds: updated);
  }

  bool reportGroup(String groupId, ReportMotif motif) {
    if (state.reportedGroupIds.contains(groupId)) return false;
    state = state.copyWith(reportedGroupIds: {...state.reportedGroupIds, groupId});
    ref.read(allGroupsProvider.notifier).incrementReportCount(groupId);
    return true;
  }
}

final safetyProvider = NotifierProvider<SafetyNotifier, SafetyState>(SafetyNotifier.new);
