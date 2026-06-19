import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../providers/group_provider.dart';
import '../screens/auth/create_profile_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/group/create_group_screen.dart';
import '../screens/group/invite_members_screen.dart';
import '../screens/matches/matches_screen.dart';
import '../screens/profile/privacy_policy_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/swipe/swipe_screen.dart';
import '../widgets/app_shell.dart';

/// Bridges Riverpod state changes into go_router's refreshListenable so the
/// redirect logic below re-runs whenever auth or group state changes, not
/// just on explicit navigation.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
    ref.listen(myGroupProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final hasGroup = ref.read(myGroupProvider) != null;
      final loc = state.matchedLocation;

      // Splash decides its own destination on a timer; privacy policy must
      // stay reachable even when logged out.
      if (loc == '/splash' || loc == '/privacy') return null;

      if (!auth.hasSession) {
        return loc == '/login' ? null : '/login';
      }
      if (!auth.isProfileComplete) {
        return loc == '/create-profile' ? null : '/create-profile';
      }
      if (!hasGroup) {
        return loc == '/create-group' ? null : '/create-group';
      }
      if (loc == '/login' || loc == '/create-profile' || loc == '/create-group') {
        return '/swipe';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/create-profile',
        builder: (context, state) => const CreateProfileScreen(),
      ),
      GoRoute(
        path: '/create-group',
        builder: (context, state) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: '/edit-group',
        builder: (context, state) => const CreateGroupScreen(isEditing: true),
      ),
      GoRoute(
        path: '/invite-members',
        builder: (context, state) => const InviteMembersScreen(),
      ),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/privacy', builder: (context, state) => const PrivacyPolicyScreen()),
      GoRoute(
        path: '/chat/:matchId',
        builder: (context, state) => ChatScreen(matchId: state.pathParameters['matchId']!),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final index = switch (state.matchedLocation) {
            '/matches' => 1,
            '/profile' => 2,
            _ => 0,
          };
          return AppShell(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(path: '/swipe', builder: (context, state) => const SwipeScreen()),
          GoRoute(path: '/matches', builder: (context, state) => const MatchesScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ],
      ),
    ],
  );
});
