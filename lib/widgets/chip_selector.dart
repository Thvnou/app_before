import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Generic selectable-chip group. The caller decides single vs multi select
/// semantics inside [onToggle] (replace the set, or add/remove from it).
class ChipSelector<T> extends StatelessWidget {
  final List<T> options;
  final Set<T> selected;
  final String Function(T option) labelBuilder;
  final void Function(T option) onToggle;

  const ChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.labelBuilder,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(labelBuilder(option)),
            selected: selected.contains(option),
            onSelected: (_) => onToggle(option),
            selectedColor: BizzColors.primary,
            backgroundColor: BizzColors.surfaceVariant,
            labelStyle: TextStyle(
              color: selected.contains(option) ? Colors.white : BizzColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: selected.contains(option) ? BizzColors.primary : BizzColors.border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BizzRadius.chip),
            ),
          ),
      ],
    );
  }
}
