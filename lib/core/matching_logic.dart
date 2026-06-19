import '../models/enums.dart';
import '../models/group_model.dart';

/// True when [other] could plausibly be interested in [viewer], based on
/// [other]'s stated genreRecherche vs. [viewer]'s dominant gender. Mixed
/// groups (either side) are always compatible.
bool genderCompatible(BeforeGroup viewer, BeforeGroup other) {
  if (other.genreRecherche == GenreRecherche.mixte) return true;
  final dominant = viewer.dominantGender;
  if (dominant == null) return true;
  if (dominant == Gender.homme && other.genreRecherche == GenreRecherche.garcons) {
    return true;
  }
  if (dominant == Gender.femme && other.genreRecherche == GenreRecherche.filles) {
    return true;
  }
  return false;
}
