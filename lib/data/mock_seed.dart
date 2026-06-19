import 'dart:math';

import 'package:flutter/material.dart' show TimeOfDay;

import '../core/id_generator.dart';
import '../models/enums.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';

/// Hand-authored demo data so the feed never feels empty during local
/// development. Mirrors what Phase 6 ("seed groups") describes, minus a
/// real backend — everything here lives only in memory.
class MockSeed {
  MockSeed._();

  static const _friendPool = [
    'Camille',
    'Hugo',
    'Manon',
    'Theo',
    'Zoe',
    'Adam',
    'Lina',
    'Mathis',
  ];

  /// A plausible random member, used to simulate a friend joining via an
  /// invite link — there's no real second device to do this for real.
  static AppUser randomFriend() {
    final random = Random();
    final prenom = _friendPool[random.nextInt(_friendPool.length)];
    final genre = Gender.values[random.nextInt(2)];
    final avatarId = random.nextInt(70) + 1;
    return AppUser(
      id: generateId('friend'),
      prenom: prenom,
      age: 19 + random.nextInt(10),
      genre: genre,
      photoUrl: 'https://i.pravatar.cc/300?img=$avatarId',
      ville: 'Toulouse',
      createdAt: DateTime.now(),
    );
  }

  static AppUser _member(
    String prenom,
    int age,
    Gender genre,
    int avatarId,
  ) {
    return AppUser(
      id: 'seed_user_${prenom}_$avatarId',
      prenom: prenom,
      age: age,
      genre: genre,
      photoUrl: 'https://i.pravatar.cc/300?img=$avatarId',
      ville: 'Toulouse',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  static List<BeforeGroup> buildSeedGroups() {
    final now = DateTime.now();

    BeforeGroup group({
      required String id,
      required String nom,
      required String description,
      required String club,
      required TimeOfDay heureSortie,
      required List<Ambiance> ambiance,
      required GenreRecherche genreRecherche,
      required List<AppUser> membres,
      bool autoLikesBack = false,
    }) {
      return BeforeGroup(
        id: id,
        nom: nom,
        description: description,
        club: club,
        heureSortie: heureSortie,
        ville: 'Toulouse',
        ambiance: ambiance,
        genreRecherche: genreRecherche,
        creePar: membres.first.id,
        membres: membres,
        actif: true,
        createdAt: now.subtract(const Duration(hours: 2)),
        isSeed: true,
        autoLikesBack: autoLikesBack,
      );
    }

    return [
      group(
        id: 'seed_g1',
        nom: 'Les Flamants Roses',
        description: 'Pre-soiree chill avant de tout donner en boite. Ambiance bonne humeur garantie.',
        club: 'La Dame de Trefle',
        heureSortie: const TimeOfDay(hour: 23, minute: 0),
        ambiance: [Ambiance.house, Ambiance.disco],
        genreRecherche: GenreRecherche.garcons,
        membres: [
          _member('Lea', 22, Gender.femme, 5),
          _member('Manon', 23, Gender.femme, 9),
          _member('Chloe', 21, Gender.femme, 16),
        ],
        autoLikesBack: true,
      ),
      group(
        id: 'seed_g2',
        nom: 'Team Tequila',
        description: 'On commence doucement et on finit en after. Qui nous rejoint ?',
        club: 'Bar Rouge',
        heureSortie: const TimeOfDay(hour: 22, minute: 30),
        ambiance: [Ambiance.pop, Ambiance.rnb],
        genreRecherche: GenreRecherche.filles,
        membres: [
          _member('Hugo', 24, Gender.homme, 12),
          _member('Nathan', 25, Gender.homme, 14),
        ],
        autoLikesBack: true,
      ),
      group(
        id: 'seed_g3',
        nom: 'Capitole Vibes',
        description: 'Petit groupe sympa, on cherche du monde pour agrandir la soiree.',
        club: "L'Envers",
        heureSortie: const TimeOfDay(hour: 21, minute: 45),
        ambiance: [Ambiance.techno],
        genreRecherche: GenreRecherche.mixte,
        membres: [
          _member('Jade', 24, Gender.femme, 20),
          _member('Tom', 26, Gender.homme, 33),
          _member('Camille', 23, Gender.autre, 28),
        ],
        autoLikesBack: true,
      ),
      group(
        id: 'seed_g4',
        nom: 'Bad Decisions',
        description: 'Comme le nom l indique. Avis aux amateurs de fous rires.',
        club: 'Le Sous-Sol',
        heureSortie: const TimeOfDay(hour: 23, minute: 30),
        ambiance: [Ambiance.afro, Ambiance.house],
        genreRecherche: GenreRecherche.garcons,
        membres: [
          _member('Sarah', 25, Gender.femme, 23),
          _member('Ines', 22, Gender.femme, 25),
          _member('Emma', 24, Gender.femme, 29),
          _member('Jade', 21, Gender.femme, 31),
        ],
      ),
      group(
        id: 'seed_g5',
        nom: 'Les Inseparables',
        description: 'Avant le Capitole, on prend un verre quelque part au calme.',
        club: 'La Cave a Vibes',
        heureSortie: const TimeOfDay(hour: 21, minute: 0),
        ambiance: [Ambiance.pop],
        genreRecherche: GenreRecherche.filles,
        membres: [
          _member('Lucas', 23, Gender.homme, 51),
          _member('Antoine', 24, Gender.homme, 52),
          _member('Maxime', 22, Gender.homme, 53),
        ],
        autoLikesBack: true,
      ),
      group(
        id: 'seed_g6',
        nom: 'Sunset Crew',
        description: 'Premiere sortie du groupe dans cette ville, on espere de belles rencontres.',
        club: 'Le Repaire',
        heureSortie: const TimeOfDay(hour: 22, minute: 0),
        ambiance: [Ambiance.disco, Ambiance.rnb],
        genreRecherche: GenreRecherche.mixte,
        membres: [
          _member('Yanis', 27, Gender.homme, 56),
          _member('Enzo', 26, Gender.homme, 59),
        ],
      ),
      group(
        id: 'seed_g7',
        nom: 'Apero Gang',
        description: 'Avant tout, un bon apero. La suite, on improvise.',
        club: "Bar du Pont",
        heureSortie: const TimeOfDay(hour: 20, minute: 30),
        ambiance: [Ambiance.afro],
        genreRecherche: GenreRecherche.garcons,
        membres: [
          _member('Noa', 22, Gender.femme, 36),
          _member('Inès', 23, Gender.femme, 38),
        ],
        autoLikesBack: true,
      ),
      group(
        id: 'seed_g8',
        nom: 'Voisins du Dessus',
        description: 'On se connait a peine mais ce soir on sort ensemble. Rejoignez-nous.',
        club: "La Grange",
        heureSortie: const TimeOfDay(hour: 23, minute: 15),
        ambiance: [Ambiance.techno, Ambiance.house],
        genreRecherche: GenreRecherche.mixte,
        membres: [
          _member('Rayan', 25, Gender.homme, 60),
          _member('Thomas', 24, Gender.homme, 13),
          _member('Leo', 23, Gender.homme, 15),
        ],
        autoLikesBack: true,
      ),
      group(
        id: 'seed_g9',
        nom: 'Last Minute Squad',
        description: 'Organise en 10 minutes, motive a 200%.',
        club: "L'Echappee",
        heureSortie: const TimeOfDay(hour: 22, minute: 45),
        ambiance: [Ambiance.pop, Ambiance.disco],
        genreRecherche: GenreRecherche.filles,
        membres: [
          _member('Maxence', 26, Gender.homme, 17),
          _member('Gabriel', 25, Gender.homme, 18),
        ],
      ),
      group(
        id: 'seed_g10',
        nom: 'La Coloc',
        description: 'Toute la coloc est de sortie ce soir, ambiance garantie jusqu au bout de la nuit.',
        club: 'Bar Rouge',
        heureSortie: const TimeOfDay(hour: 21, minute: 30),
        ambiance: [Ambiance.rnb, Ambiance.afro],
        genreRecherche: GenreRecherche.mixte,
        membres: [
          _member('Camille', 24, Gender.femme, 26),
          _member('Hugo', 25, Gender.homme, 11),
          _member('Manon', 23, Gender.femme, 10),
          _member('Antoine', 26, Gender.homme, 50),
        ],
        autoLikesBack: true,
      ),
    ];
  }
}
