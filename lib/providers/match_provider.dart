import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/id_generator.dart';
import '../models/group_model.dart';
import '../models/match_model.dart';

class MatchNotifier extends Notifier<List<BeforeMatch>> {
  @override
  List<BeforeMatch> build() => [];

  BeforeMatch createMatch(BeforeGroup myGroup, BeforeGroup otherGroup) {
    final existing = state.where((m) => m.otherGroup.id == otherGroup.id);
    if (existing.isNotEmpty) return existing.first;

    final match = BeforeMatch(
      id: generateId('match'),
      myGroup: myGroup,
      otherGroup: otherGroup,
      createdAt: DateTime.now(),
    );
    state = [match, ...state];
    return match;
  }

  void markBeforeTermine(String matchId) {
    state = [
      for (final m in state)
        if (m.id == matchId) m.copyWith(beforeTermine: true) else m,
    ];
  }
}

final matchProvider = NotifierProvider<MatchNotifier, List<BeforeMatch>>(MatchNotifier.new);
