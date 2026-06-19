import 'dart:typed_data';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/id_generator.dart';
import '../data/mock_seed.dart';
import '../models/enums.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import 'auth_provider.dart';

/// Every before posted by *other* groups — the pool the feed is drawn from.
class AllGroupsNotifier extends Notifier<List<BeforeGroup>> {
  @override
  List<BeforeGroup> build() => MockSeed.buildSeedGroups();

  void incrementReportCount(String groupId) {
    state = [
      for (final g in state)
        if (g.id == groupId) g.copyWith(reportCount: g.reportCount + 1) else g,
    ];
  }
}

final allGroupsProvider = NotifierProvider<AllGroupsNotifier, List<BeforeGroup>>(
  AllGroupsNotifier.new,
);

/// The current user's own before — created once during onboarding, then
/// editable from the Profile tab. Null until the user creates one.
class MyGroupNotifier extends Notifier<BeforeGroup?> {
  @override
  BeforeGroup? build() => null;

  void createGroup({
    required String nom,
    required String description,
    String? photoUrl,
    Uint8List? photoBytes,
    required String club,
    required TimeOfDay heureSortie,
    required List<Ambiance> ambiance,
    required GenreRecherche genreRecherche,
  }) {
    final me = ref.read(authProvider).profile;
    if (me == null) return;
    state = BeforeGroup(
      id: generateId('mygroup'),
      nom: nom,
      description: description,
      photoUrl: photoUrl,
      photoBytes: photoBytes,
      club: club,
      heureSortie: heureSortie,
      ville: me.ville,
      ambiance: ambiance,
      genreRecherche: genreRecherche,
      creePar: me.id,
      membres: [me],
      createdAt: DateTime.now(),
    );
  }

  void update({
    String? nom,
    String? description,
    String? photoUrl,
    Uint8List? photoBytes,
    String? club,
    TimeOfDay? heureSortie,
    List<Ambiance>? ambiance,
    GenreRecherche? genreRecherche,
  }) {
    if (state == null) return;
    state = state!.copyWith(
      nom: nom,
      description: description,
      photoUrl: photoUrl,
      photoBytes: photoBytes,
      club: club,
      heureSortie: heureSortie,
      ambiance: ambiance,
      genreRecherche: genreRecherche,
    );
  }

  bool addMember(AppUser member) {
    final current = state;
    if (current == null) return false;
    if (current.membres.length >= 8) return false;
    if (current.membres.any((m) => m.id == member.id)) return false;
    state = current.copyWith(membres: [...current.membres, member]);
    return true;
  }

  void removeMember(String memberId) {
    final current = state;
    if (current == null) return;
    if (memberId == current.creePar) return;
    state = current.copyWith(
      membres: current.membres.where((m) => m.id != memberId).toList(),
    );
  }

  void clear() => state = null;
}

final myGroupProvider = NotifierProvider<MyGroupNotifier, BeforeGroup?>(
  MyGroupNotifier.new,
);
