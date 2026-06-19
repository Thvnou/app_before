import 'group_model.dart';

/// A symmetric match between the current user's group and another group.
class BeforeMatch {
  final String id;
  final BeforeGroup myGroup;
  final BeforeGroup otherGroup;
  final DateTime createdAt;
  final bool beforeTermine;

  const BeforeMatch({
    required this.id,
    required this.myGroup,
    required this.otherGroup,
    required this.createdAt,
    this.beforeTermine = false,
  });

  BeforeMatch copyWith({bool? beforeTermine}) {
    return BeforeMatch(
      id: id,
      myGroup: myGroup,
      otherGroup: otherGroup,
      createdAt: createdAt,
      beforeTermine: beforeTermine ?? this.beforeTermine,
    );
  }
}
