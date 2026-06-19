import 'package:flutter/material.dart' show TimeOfDay;

/// Formats a TimeOfDay as "23h" or "23h30", without needing a BuildContext.
String formatHeure(TimeOfDay t) {
  final hour = t.hour.toString().padLeft(2, '0');
  if (t.minute == 0) return '${hour}h';
  final minute = t.minute.toString().padLeft(2, '0');
  return '${hour}h$minute';
}
