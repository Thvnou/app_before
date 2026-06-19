/// Gender of an individual user.
enum Gender { homme, femme, autre }

extension GenderLabel on Gender {
  String get label => switch (this) {
        Gender.homme => 'Homme',
        Gender.femme => 'Femme',
        Gender.autre => 'Autre',
      };
}

/// Who a before group is looking to match with.
enum GenreRecherche { filles, garcons, mixte }

extension GenreRechercheLabel on GenreRecherche {
  String get label => switch (this) {
        GenreRecherche.filles => 'Cherche des filles',
        GenreRecherche.garcons => 'Cherche des garcons',
        GenreRecherche.mixte => 'Tout le monde',
      };

  String get shortLabel => switch (this) {
        GenreRecherche.filles => 'Filles',
        GenreRecherche.garcons => 'Garcons',
        GenreRecherche.mixte => 'Mixte',
      };
}

/// Musical mood tags a before can advertise.
enum Ambiance { techno, house, afro, rnb, pop, disco }

extension AmbianceLabel on Ambiance {
  String get label => switch (this) {
        Ambiance.techno => 'Techno',
        Ambiance.house => 'House',
        Ambiance.afro => 'Afro',
        Ambiance.rnb => 'RnB',
        Ambiance.pop => 'Pop',
        Ambiance.disco => 'Disco',
      };
}

/// Reasons a group can be reported for.
enum ReportMotif { contenuInapproprie, fauxProfil, comportementSuspect, autre }

extension ReportMotifLabel on ReportMotif {
  String get label => switch (this) {
        ReportMotif.contenuInapproprie => 'Contenu inapproprie',
        ReportMotif.fauxProfil => 'Faux profil',
        ReportMotif.comportementSuspect => 'Comportement suspect',
        ReportMotif.autre => 'Autre',
      };
}

/// Direction of a swipe gesture on the feed.
enum SwipeDirection { left, right }
