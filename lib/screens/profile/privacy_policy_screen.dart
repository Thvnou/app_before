import 'package:flutter/material.dart';

import '../../core/theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confidentialite')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            Text(
              'Politique de confidentialite',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 16),
            _Section(
              title: 'Donnees collectees',
              body:
                  "Bizz collecte uniquement les informations necessaires a ton profil et a tes before : prenom, age, genre, ville, photo, et les groupes que tu crees ou rejoins.",
            ),
            _Section(
              title: 'Utilisation',
              body:
                  'Ces donnees servent uniquement a faire fonctionner le fil de swipe, les matchs et la messagerie entre groupes. Elles ne sont jamais vendues a des tiers.',
            ),
            _Section(
              title: 'Securite',
              body:
                  'Tu peux signaler ou bloquer un groupe a tout moment. Un groupe signale 3 fois est automatiquement masque en attendant moderation.',
            ),
            _Section(
              title: 'Tes droits',
              body:
                  'Tu peux supprimer ton compte et toutes tes donnees a tout moment depuis Profil > Parametres > Supprimer mon compte.',
            ),
            _Section(
              title: 'Contact',
              body: 'Pour toute question : contact@bizz-app.fr',
            ),
            SizedBox(height: 24),
            Text(
              'Document indicatif pour la version de developpement.',
              style: TextStyle(color: BizzColors.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: BizzColors.textSecondary, height: 1.4)),
        ],
      ),
    );
  }
}
