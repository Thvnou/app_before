import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideDestination();
  }

  Future<void> _decideDestination() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final auth = ref.read(authProvider);
    if (!auth.hasSession) {
      context.go('/login');
    } else if (!auth.isProfileComplete) {
      context.go('/create-profile');
    } else if (ref.read(myGroupProvider) == null) {
      context.go('/create-group');
    } else {
      context.go('/swipe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizzColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: BizzColors.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: const Text(
                'B',
                style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bizz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ton before commence ici',
              style: TextStyle(color: BizzColors.textSecondary),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
      ),
    );
  }
}
