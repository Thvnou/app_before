import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/photo_picker.dart';
import '../../core/theme.dart';
import '../../models/enums.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/bizz_avatar.dart';
import '../../widgets/chip_selector.dart';
import '../../widgets/primary_button.dart';

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _prenomController = TextEditingController();
  final _villeController = TextEditingController(text: BizzConstants.defaultCity);
  int _age = 18;
  Gender? _genre;
  Uint8List? _photoBytes;
  bool _cguAccepted = false;
  bool _saving = false;

  @override
  void dispose() {
    _prenomController.dispose();
    _villeController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _prenomController.text.trim().isNotEmpty && _genre != null && _cguAccepted && !_saving;

  Future<void> _pickPhoto() async {
    final bytes = await pickPhotoFromSheet(context);
    if (bytes == null) return;
    setState(() => _photoBytes = bytes);
  }

  Future<void> _continue() async {
    if (!_canContinue) return;
    setState(() => _saving = true);
    await ref.read(authProvider.notifier).saveProfile(
          prenom: _prenomController.text.trim(),
          age: _age,
          genre: _genre!,
          photoBytes: _photoBytes,
          ville: _villeController.text.trim().isEmpty
              ? BizzConstants.defaultCity
              : _villeController.text.trim(),
        );
    if (!mounted) return;
    context.go('/create-group');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ton profil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Stack(
                    children: [
                      BizzAvatar(
                        photoBytes: _photoBytes,
                        fallbackText: _prenomController.text.isNotEmpty
                            ? _prenomController.text[0].toUpperCase()
                            : '+',
                        radius: 56,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: BizzColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              AppTextField(
                label: 'Prenom',
                controller: _prenomController,
                hint: 'Ton prenom',
                maxLength: BizzConstants.prenomMaxLength,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),
              const Text('Age', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: BizzColors.surface,
                  borderRadius: BorderRadius.circular(BizzRadius.button),
                  border: Border.all(color: BizzColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => setState(
                        () => _age = (_age - 1).clamp(BizzConstants.minAge, BizzConstants.maxAge).toInt(),
                      ),
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                    ),
                    Text(
                      '$_age ans',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () => setState(
                        () => _age = (_age + 1).clamp(BizzConstants.minAge, BizzConstants.maxAge).toInt(),
                      ),
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Genre', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              ChipSelector<Gender>(
                options: Gender.values,
                selected: _genre == null ? {} : {_genre!},
                labelBuilder: (g) => g.label,
                onToggle: (g) => setState(() => _genre = g),
              ),
              const SizedBox(height: 20),
              AppTextField(label: 'Ville', controller: _villeController, hint: 'Toulouse'),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _cguAccepted,
                    onChanged: (v) => setState(() => _cguAccepted = v ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text.rich(
                        TextSpan(
                          text: "J'accepte les ",
                          style: const TextStyle(color: BizzColors.textSecondary, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'CGU et la politique de confidentialite',
                              style: const TextStyle(
                                color: BizzColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.push('/privacy'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Continuer',
                loading: _saving,
                onPressed: _canContinue ? _continue : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
