import 'dart:typed_data';
import 'package:flutter/material.dart' show TimeOfDay;

import 'enums.dart';
import 'user_model.dart';

/// A "before" — a group's pre-party plan posted to the feed.
/// This is the central content unit of Bizz: who's going, how many,
/// where, and who they're hoping to meet there.
class BeforeGroup {
  final String id;
  final String nom;
  final String description;
  final String? photoUrl;
  final Uint8List? photoBytes;
  final String club;
  final TimeOfDay heureSortie;
  final String ville;
  final List<Ambiance> ambiance;
  final GenreRecherche genreRecherche;
  final String creePar;
  final List<AppUser> membres;
  final bool actif;
  final DateTime createdAt;
  final bool isSeed;
  final bool autoLikesBack;
  final int reportCount;

  const BeforeGroup({
    required this.id,
    required this.nom,
    required this.description,
    this.photoUrl,
    this.photoBytes,
    required this.club,
    required this.heureSortie,
    this.ville = 'Toulouse',
    required this.ambiance,
    required this.genreRecherche,
    required this.creePar,
    required this.membres,
    this.actif = true,
    required this.createdAt,
    this.isSeed = false,
    this.autoLikesBack = false,
    this.reportCount = 0,
  });

  int get tailleGroupe => membres.length;

  String get agesLabel => membres.map((m) => m.age).join(', ');

  bool get isSuspended => reportCount >= 3;

  /// Majority gender among members, or null if mixed/tied — used to decide
  /// which groups show up in each other's feed.
  Gender? get dominantGender {
    if (membres.isEmpty) return null;
    final counts = <Gender, int>{};
    for (final m in membres) {
      counts[m.genre] = (counts[m.genre] ?? 0) + 1;
    }
    if (counts.length == 1) return counts.keys.first;
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (sorted[0].value == sorted[1].value) return null;
    return sorted[0].key;
  }

  BeforeGroup copyWith({
    String? nom,
    String? description,
    String? photoUrl,
    Uint8List? photoBytes,
    String? club,
    TimeOfDay? heureSortie,
    String? ville,
    List<Ambiance>? ambiance,
    GenreRecherche? genreRecherche,
    List<AppUser>? membres,
    bool? actif,
    int? reportCount,
  }) {
    return BeforeGroup(
      id: id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      photoBytes: photoBytes ?? this.photoBytes,
      club: club ?? this.club,
      heureSortie: heureSortie ?? this.heureSortie,
      ville: ville ?? this.ville,
      ambiance: ambiance ?? this.ambiance,
      genreRecherche: genreRecherche ?? this.genreRecherche,
      creePar: creePar,
      membres: membres ?? this.membres,
      actif: actif ?? this.actif,
      createdAt: createdAt,
      isSeed: isSeed,
      autoLikesBack: autoLikesBack,
      reportCount: reportCount ?? this.reportCount,
    );
  }
}
