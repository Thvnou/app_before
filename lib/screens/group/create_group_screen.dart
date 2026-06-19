import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/format_utils.dart';
import '../../core/photo_picker.dart';
import '../../core/theme.dart';
import '../../models/enums.dart';
import '../../providers/group_provider.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/bizz_avatar.dart';
import '../../widgets/chip_selector.dart';
import '../../widgets/primary_button.dart';

/// Used both for the initial onboarding before ([isEditing] = false, only
/// reachable while the user has no group yet) and to edit an existing
/// before from the Profile tab ([isEditing] = true).
class CreateGroupScreen extends ConsumerStatefulWidget {
  final bool isEditing;

  const CreateGroupScreen({super.key, this.isEditing = false});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _clubController = TextEditingController();
  int _targetSize = 4;
  TimeOfDay _heureSortie = const TimeOfDay(hour: 23, minute: 0);
  Set<Ambiance> _ambiance = {};
  GenreRecherche _genreRecherche = GenreRecherche.mixte;
  Uint8List? _photoBytes;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      final group = ref.read(myGroupProvider);
      if (group != null) {
        _nomController.text = group.nom;
        _descriptionController.text = group.description;
        _clubController.text = group.club;
        _heureSortie = group.heureSortie;
        _ambiance = group.ambiance.toSet();
        _genreRecherche = group.genreRecherche;
        _photoBytes = group.photoBytes;
        _targetSize = group.membres.length.clamp(
          BizzConstants.groupMinMembers,
          BizzConstants.groupMaxMembers,
        );
      }
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _clubController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _nomController.text.trim().isNotEmpty && _clubController.text.trim().isNotEmpty && !_saving;

  Future<void> _pickPhoto() async {
    final bytes = await pickPhotoFromSheet(context);
    if (bytes == null) return;
    setState(() => _photoBytes = bytes);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _heureSortie);
    if (picked != null) setState(() => _heureSortie = picked);
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _saving = true);

    if (widget.isEditing) {
      ref.read(myGroupProvider.notifier).update(
            nom: _nomController.text.trim(),
            description: _descriptionController.text.trim(),
            photoBytes: _photoBytes,
            club: _clubController.text.trim(),
            heureSortie: _heureSortie,
            ambiance: _ambiance.toList(),
            genreRecherche: _genreRecherche,
          );
    } else {
      ref.read(myGroupProvider.notifier).createGroup(
            nom: _nomController.text.trim(),
            description: _descriptionController.text.trim(),
            photoBytes: _photoBytes,
            club: _clubController.text.trim(),
            heureSortie: _heureSortie,
            ambiance: _ambiance.toList(),
            genreRecherche: _genreRecherche,
          );
    }

    if (!mounted) return;
    if (widget.isEditing) {
      context.pop();
    } else {
      context.go('/swipe');
    }
  }

  void _skip() {
    ref.read(myGroupProvider.notifier).createGroup(
          nom: 'Mon before',
          description: '',
          club: 'A definir',
          heureSortie: const TimeOfDay(hour: 23, minute: 0),
          ambiance: const [],
          genreRecherche: GenreRecherche.mixte,
        );
    context.go('/swipe');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifier mon before' : 'Cree ton before'),
        automaticallyImplyLeading: widget.isEditing,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!widget.isEditing)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Avant de swiper, presente ta soiree : qui vient, ou vous allez, et qui vous esperez croiser.',
                    style: TextStyle(color: BizzColors.textSecondary),
                  ),
                ),
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Stack(
                    children: [
                      BizzAvatar(photoBytes: _photoBytes, fallbackText: '?', radius: 48),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: BizzColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Nom du groupe',
                controller: _nomController,
                hint: 'Les Loulous',
                maxLength: BizzConstants.groupNomMaxLength,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Description',
                controller: _descriptionController,
                hint: 'Quelques mots sur votre soiree...',
                maxLength: BizzConstants.groupDescriptionMaxLength,
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              if (!widget.isEditing) ...[
                const Text(
                  'Combien serez-vous ?',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
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
                          () => _targetSize = (_targetSize - 1)
                              .clamp(BizzConstants.groupMinMembers, BizzConstants.groupMaxMembers)
                              .toInt(),
                        ),
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                      ),
                      Text(
                        '$_targetSize personnes',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        onPressed: () => setState(
                          () => _targetSize = (_targetSize + 1)
                              .clamp(BizzConstants.groupMinMembers, BizzConstants.groupMaxMembers)
                              .toInt(),
                        ),
                        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tu pourras inviter tes amis juste apres avoir publie ton before.",
                  style: TextStyle(color: BizzColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 20),
              ],
              AppTextField(
                label: 'Club / bar vise ce soir',
                controller: _clubController,
                hint: 'Le Repaire',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),
              const Text(
                'Heure de sortie',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(BizzRadius.button),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: BizzColors.surface,
                    borderRadius: BorderRadius.circular(BizzRadius.button),
                    border: Border.all(color: BizzColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: BizzColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Text('Ce soir ${formatHeure(_heureSortie)}', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ambiance musicale',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ChipSelector<Ambiance>(
                options: Ambiance.values,
                selected: _ambiance,
                labelBuilder: (a) => a.label,
                onToggle: (a) => setState(() {
                  _ambiance.contains(a) ? _ambiance.remove(a) : _ambiance.add(a);
                }),
              ),
              const SizedBox(height: 20),
              const Text(
                'On cherche',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ChipSelector<GenreRecherche>(
                options: GenreRecherche.values,
                selected: {_genreRecherche},
                labelBuilder: (g) => g.shortLabel,
                onToggle: (g) => setState(() => _genreRecherche = g),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: widget.isEditing ? 'Enregistrer' : 'Publier le before',
                loading: _saving,
                onPressed: _canSubmit ? _submit : null,
              ),
              if (!widget.isEditing) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: _skip,
                    child: const Text('Passer pour l\'instant', style: TextStyle(color: BizzColors.textSecondary)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
