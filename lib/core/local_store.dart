import 'package:shared_preferences/shared_preferences.dart';

import '../models/enums.dart';
import '../models/user_model.dart';

/// Thin wrapper around SharedPreferences. Stands in for "session persistence"
/// since there is no backend — only the auth session and the individual
/// profile survive an app restart. A group ("before") is intentionally
/// per-session: in the real product a before expires at midnight anyway.
class LocalStore {
  LocalStore._(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStore._(prefs);
  }

  bool get hasSession => _prefs.getBool('bizz_session') ?? false;

  Future<void> setSession(bool value) => _prefs.setBool('bizz_session', value);

  AppUser? get profile {
    final id = _prefs.getString('bizz_profile_id');
    if (id == null) return null;
    final genreName = _prefs.getString('bizz_profile_genre') ?? Gender.autre.name;
    return AppUser(
      id: id,
      prenom: _prefs.getString('bizz_profile_prenom') ?? '',
      age: _prefs.getInt('bizz_profile_age') ?? 18,
      genre: Gender.values.byName(genreName),
      photoUrl: _prefs.getString('bizz_profile_photoUrl'),
      ville: _prefs.getString('bizz_profile_ville') ?? 'Toulouse',
      createdAt: DateTime.tryParse(_prefs.getString('bizz_profile_createdAt') ?? '') ??
          DateTime.now(),
    );
  }

  Future<void> saveProfile(AppUser user) async {
    await _prefs.setString('bizz_profile_id', user.id);
    await _prefs.setString('bizz_profile_prenom', user.prenom);
    await _prefs.setInt('bizz_profile_age', user.age);
    await _prefs.setString('bizz_profile_genre', user.genre.name);
    await _prefs.setString('bizz_profile_ville', user.ville);
    await _prefs.setString('bizz_profile_createdAt', user.createdAt.toIso8601String());
    if (user.photoUrl != null) {
      await _prefs.setString('bizz_profile_photoUrl', user.photoUrl!);
    }
  }

  bool get cguAccepted => _prefs.getBool('bizz_cgu_accepted') ?? false;

  Future<void> setCguAccepted(bool value) => _prefs.setBool('bizz_cgu_accepted', value);

  Future<void> clearAll() => _prefs.clear();
}
