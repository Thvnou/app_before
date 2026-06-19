import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final notifier = ref.read(authProvider.notifier);
    final ok = _isSignUp
        ? await notifier.signUp(email: _emailController.text, password: _passwordController.text)
        : await notifier.signIn(email: _emailController.text, password: _passwordController.text);

    if (!mounted) return;
    if (ok) {
      context.go('/swipe');
    } else {
      final error = ref.read(authProvider).error ?? 'Une erreur est survenue';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: BizzColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'B',
                        style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isSignUp ? 'Cree ton compte' : 'Content de te revoir',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isSignUp
                          ? 'Rejoins la nightlife de Toulouse'
                          : 'Connecte-toi pour retrouver ton before',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: BizzColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                hint: 'toi@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Mot de passe',
                controller: _passwordController,
                hint: '********',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: _isSignUp ? 'Creer un compte' : 'Se connecter',
                loading: auth.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(
                    _isSignUp ? 'Deja un compte ? Se connecter' : "Pas encore de compte ? S'inscrire",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.push('/privacy'),
                  child: const Text(
                    'Politique de confidentialite',
                    style: TextStyle(color: BizzColors.textSecondary, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
