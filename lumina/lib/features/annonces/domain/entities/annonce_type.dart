class AnnonceType {
  final String value;
  final String label;
  final String icon;

  const AnnonceType._({
    required this.value,
    required this.label,
    required this.icon,
  });

  static const AnnonceType actualite = AnnonceType._(
    value: 'actualite',
    label: 'Actualité',
    icon: '📰',
  );

  static const AnnonceType annonce = AnnonceType._(
    value: 'annonce',
    label: 'Annonce',
    icon: '📢',
  );

  static const AnnonceType predication = AnnonceType._(
    value: 'predication',
    label: 'Prédication',
    icon: '',
  );

  static const AnnonceType evenement = AnnonceType._(
    value: 'evenement',
    label: 'Événement',
    icon: '📅',
  );

  static const AnnonceType louange = AnnonceType._(
    value: 'louange',
    label: 'Louange',
    icon: '',
  );

  static const AnnonceType temoignage = AnnonceType._(
    value: 'temoignage',
    label: 'Témoignage',
    icon: '',
  );

  static const AnnonceType education = AnnonceType._(
    value: 'education',
    label: 'Éducation',
    icon: '📚',
  );

  static const AnnonceType autre = AnnonceType._(
    value: 'autre',
    label: 'Autre',
    icon: '📝',
  );

  static const List<AnnonceType> allTypes = [
    actualite,
    annonce,
    predication,
    evenement,
    louange,
    temoignage,
    education,
    autre,
  ];

  static AnnonceType fromString(String value) {
    for (final type in allTypes) {
      if (type.value.toLowerCase() == value.toLowerCase()) {
        return type;
      }
    }
    throw ArgumentError('Unknown annonce type: $value');
  }

  @override
  String toString() => value;
}