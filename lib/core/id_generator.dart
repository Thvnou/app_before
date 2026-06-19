int _counter = 0;

/// Generates a unique, sortable-enough id for locally created records.
/// No backend means no DB-generated UUIDs, so this stands in for one.
String generateId(String prefix) {
  _counter++;
  return '${prefix}_${DateTime.now().microsecondsSinceEpoch}_$_counter';
}
