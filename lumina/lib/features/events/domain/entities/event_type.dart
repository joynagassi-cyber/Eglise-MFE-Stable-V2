class EventType {
  final String value;
  final String label;
  final String icon;

  const EventType._({
    required this.value,
    required this.label,
    required this.icon,
  });

  static const EventType mass = EventType._(
    value: 'mass',
    label: 'Messe',
    icon: '',
  );

  static const EventType wedding = EventType._(
    value: 'wedding',
    label: 'Mariage',
    icon: '💍',
  );

  static const EventType baptism = EventType._(
    value: 'baptism',
    label: 'Baptême',
    icon: '💧',
  );

  static const EventType confirmation = EventType._(
    value: 'confirmation',
    label: 'Confirmation',
    icon: '',
  );

  static const EventType firstCommunion = EventType._(
    value: 'first_communion',
    label: 'Première Communion',
    icon: '🕊️',
  );

  static const EventType anointing = EventType._(
    value: 'anointing',
    label: 'Onction des Malades',
    icon: '',
  );

  static const EventType meeting = EventType._(
    value: 'meeting',
    label: 'Réunion',
    icon: '👥',
  );

  static const EventType conference = EventType._(
    value: 'conference',
    label: 'Conférence',
    icon: '',
  );

  static const EventType retreat = EventType._(
    value: 'retreat',
    label: 'Retraite',
    icon: '🏕',
  );

  static const EventType other = EventType._(
    value: 'other',
    label: 'Autre',
    icon: '📅',
  );

  static const List<EventType> allTypes = [
    mass,
    wedding,
    baptism,
    confirmation,
    firstCommunion,
    anointing,
    meeting,
    conference,
    retreat,
    other,
  ];

  static EventType fromString(String value) {
    for (final type in allTypes) {
      if (type.value.toLowerCase() == value.toLowerCase()) {
        return type;
      }
    }
    throw ArgumentError('Unknown event type: $value');
  }

  String get name => value;

  @override
  String toString() => value;
}