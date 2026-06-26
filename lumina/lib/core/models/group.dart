// ============================================================
// FICHIER : lib/core/models/group.dart
// DESCRIPTION : Modèle Group mappé depuis la table 'groups'
// DÉPENDANCES : aucune (pur Dart)
// ============================================================

class Group {
  final String id;
  final String churchId;
  final String name;
  final String type;
  final String? leaderId;
  final double budgetAllocated;
  final double budgetUsed;
  final String? color;
  final String? icon;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.churchId,
    required this.name,
    this.type = 'general',
    this.leaderId,
    this.budgetAllocated = 0,
    this.budgetUsed = 0,
    this.color,
    this.icon,
    required this.createdAt,
  });

  double get budgetRemaining => budgetAllocated - budgetUsed;

  double get budgetUsagePercent =>
      budgetAllocated > 0 ? (budgetUsed / budgetAllocated * 100) : 0;

  bool get isBudgetExceeded => budgetUsed > budgetAllocated;

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      leaderId: json['leader_id'] as String?,
      budgetAllocated: (json['budget_allocated'] as num?)?.toDouble() ?? 0,
      budgetUsed: (json['budget_used'] as num?)?.toDouble() ?? 0,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'name': name,
      'type': type,
      'leader_id': leaderId,
      'budget_allocated': budgetAllocated,
      'budget_used': budgetUsed,
      'color': color,
      'icon': icon,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Group copyWith({
    String? id,
    String? churchId,
    String? name,
    String? type,
    String? leaderId,
    double? budgetAllocated,
    double? budgetUsed,
    String? color,
    String? icon,
    DateTime? createdAt,
  }) {
    return Group(
      id: id ?? this.id,
      churchId: churchId ?? this.churchId,
      name: name ?? this.name,
      type: type ?? this.type,
      leaderId: leaderId ?? this.leaderId,
      budgetAllocated: budgetAllocated ?? this.budgetAllocated,
      budgetUsed: budgetUsed ?? this.budgetUsed,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Group($name, type: $type)';
}
