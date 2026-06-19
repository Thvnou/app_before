import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/id_generator.dart';
import '../core/local_store.dart';
import '../models/enums.dart';
import '../models/user_model.dart';

/// Throws if used before main() overrides it with a loaded [LocalStore].
final localStoreProvider = Provider<LocalStore>((ref) {
  throw UnimplementedError('localStoreProvider must be overridden in main()');
});

class AuthState {
  final bool isLoading;
  final bool hasSession;
  final AppUser? profile;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.hasSession = false,
    this.profile,
    this.error,
  });

  bool get isProfileComplete => profile != null;

  AuthState copyWith({
    bool? isLoading,
    bool? hasSession,
    AppUser? profile,
    bool clearProfile = false,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      hasSession: hasSession ?? this.hasSession,
      profile: clearProfile ? null : (profile ?? this.profile),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final store = ref.watch(localStoreProvider);
    return AuthState(hasSession: store.hasSession, profile: store.profile);
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!_isValidEmail(email)) {
      state = state.copyWith(isLoading: false, error: 'Adresse email invalide');
      return false;
    }
    if (password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        error: 'Email ou mot de passe incorrect',
      );
      return false;
    }

    final store = ref.read(localStoreProvider);
    await store.setSession(true);
    state = state.copyWith(isLoading: false, hasSession: true, profile: store.profile);
    return true;
  }

  Future<bool> signUp({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!_isValidEmail(email)) {
      state = state.copyWith(isLoading: false, error: 'Adresse email invalide');
      return false;
    }
    if (password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        error: 'Le mot de passe doit contenir au moins 6 caracteres',
      );
      return false;
    }

    final store = ref.read(localStoreProvider);
    await store.setSession(true);
    state = state.copyWith(isLoading: false, hasSession: true);
    return true;
  }

  Future<void> saveProfile({
    required String prenom,
    required int age,
    required Gender genre,
    String? photoUrl,
    Uint8List? photoBytes,
    required String ville,
  }) async {
    final user = AppUser(
      id: state.profile?.id ?? generateId('user'),
      prenom: prenom,
      age: age,
      genre: genre,
      photoUrl: photoUrl,
      photoBytes: photoBytes,
      ville: ville,
      createdAt: state.profile?.createdAt ?? DateTime.now(),
    );
    final store = ref.read(localStoreProvider);
    await store.saveProfile(user);
    await store.setCguAccepted(true);
    state = state.copyWith(profile: user);
  }

  Future<void> signOut() async {
    final store = ref.read(localStoreProvider);
    await store.clearAll();
    state = const AuthState();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
