import 'dart:typed_data';

import 'enums.dart';

/// An individual user's personal profile (independent of any group).
class AppUser {
  final String id;
  final String prenom;
  final int age;
  final Gender genre;
  final String? photoUrl;
  final Uint8List? photoBytes;
  final String ville;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.prenom,
    required this.age,
    required this.genre,
    this.photoUrl,
    this.photoBytes,
    this.ville = 'Toulouse',
    required this.createdAt,
  });

  AppUser copyWith({
    String? prenom,
    int? age,
    Gender? genre,
    String? photoUrl,
    Uint8List? photoBytes,
    String? ville,
  }) {
    return AppUser(
      id: id,
      prenom: prenom ?? this.prenom,
      age: age ?? this.age,
      genre: genre ?? this.genre,
      photoUrl: photoUrl ?? this.photoUrl,
      photoBytes: photoBytes ?? this.photoBytes,
      ville: ville ?? this.ville,
      createdAt: createdAt,
    );
  }
}
