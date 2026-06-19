/// App-wide constants. Centralised so validation rules and limits live in one place.
class BizzConstants {
  BizzConstants._();

  static const String appName = 'Bizz';
  static const String defaultCity = 'Toulouse';

  static const int minAge = 18;
  static const int maxAge = 50;

  static const int prenomMaxLength = 20;
  static const int groupNomMaxLength = 30;
  static const int groupDescriptionMaxLength = 150;
  static const int messageMaxLength = 500;

  static const int groupMinMembers = 2;
  static const int groupMaxMembers = 8;

  static const List<String> quickReplies = [
    'On se retrouve ou ?',
    'A quelle heure ?',
    'On est combien dans le groupe ?',
    'Vous arrivez vers quelle heure ?',
  ];
}
