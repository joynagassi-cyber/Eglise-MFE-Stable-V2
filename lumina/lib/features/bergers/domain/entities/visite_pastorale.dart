import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'visite_pastorale.freezed.dart';

/// ═══════════════════════════════════════════════════════════════════════════════
/// VISITE PASTORALE - Modèle Défensif SRE
///
/// Règles:
/// • Validation stricte des statuts
/// • Parsing défensif des dates
/// • Jointures null-safe (membreNom, bergerNom)
/// • Helpers pour l'UI (isEnRetard, displayAdresse, etc.)
/// ═══════════════════════════════════════════════════════════════════════════════

enum StatutVisite { planifiee, effectuee, annulee }

enum PrioriteVisite { basse, moyenne, haute }

@freezed
class VisitePastorale with _$VisitePastorale {
  const factory VisitePastorale({
    required String id,
    required String churchId,
    required String membreId,
    String? membreNom, // Nullable car jointure
    required String bergerId,
    String? bergerNom, // Nullable car jointure
    required DateTime dateVisite,
    @Default('') String adresse,
    @Default('') String motif,
    @Default('') String notes,
    @Default(StatutVisite.planifiee) StatutVisite statut,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VisitePastorale;

  const VisitePastorale._();

  /// Factory défensive avec validation des statuts
  factory VisitePastorale.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final churchId = json['church_id'] as String?;
    final membreId = json['membre_id'] as String?;
    final bergerId = json['berger_id'] as String?;
    final dateVisiteStr = json['date_visite'] as String?;

    if (id == null || id.isEmpty) {
      throw FormatException('VisitePastorale: id est null', json);
    }
    if (churchId == null || churchId.isEmpty) {
      throw FormatException('VisitePastorale: churchId est null', json);
    }
    if (membreId == null || membreId.isEmpty) {
      throw FormatException('VisitePastorale: membre_id est null', json);
    }
    if (bergerId == null || bergerId.isEmpty) {
      throw FormatException('VisitePastorale: berger_id est null', json);
    }
    if (dateVisiteStr == null || dateVisiteStr.isEmpty) {
      throw FormatException('VisitePastorale: date_visite est null', json);
    }

    final dateVisite = DateTime.tryParse(dateVisiteStr);
    if (dateVisite == null) {
      throw FormatException('VisitePastorale: date_visite invalide', json);
    }

    // Parsing du statut avec fallback sécurisé
    final statutStr = json['statut'] as String? ?? 'planifiee';
    final statut = _parseStatut(statutStr);

    // Parsing des jointures (peuvent être null si la relation n'existe pas)
    final membres = json['membres'] as Map<String, dynamic>?;
    final bergers = json['bergers'] as Map<String, dynamic>?;

    String? membreNom;
    if (membres != null) {
      final prenom = membres['prenom'] as String? ?? '';
      final nom = membres['nom'] as String? ?? '';
      membreNom = '$prenom $nom'.trim();
      if (membreNom.isEmpty) membreNom = 'Membre inconnu';
    }

    String? bergerNom;
    if (bergers != null) {
      final email = bergers['email'] as String?;
      bergerNom = bergers['nom'] as String? ?? email ?? 'Berger inconnu';
    }

    return VisitePastorale(
      id: id,
      churchId: churchId,
      membreId: membreId,
      membreNom: membreNom,
      bergerId: bergerId,
      bergerNom: bergerNom,
      dateVisite: dateVisite,
      adresse: _parseString(json['adresse'], defaultValue: ''),
      motif: _parseString(json['motif'], defaultValue: 'Visite pastorale'),
      notes: _parseString(json['notes'], defaultValue: ''),
      statut: statut,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // GETTERS SÛRS - Logique métier défensive
  // ─────────────────────────────────────────────────────────────────────────────

  bool get isPlanifiee => statut == StatutVisite.planifiee;
  bool get isEffectuee => statut == StatutVisite.effectuee;
  bool get isAnnulee => statut == StatutVisite.annulee;

  /// Vérifie si la visite est en retard (planifiée mais date passée de plus de 24h)
  bool get isEnRetard {
    if (!isPlanifiee) return false;
    final now = DateTime.now();
    final limit = dateVisite.add(const Duration(hours: 24));
    return now.isAfter(limit);
  }

  /// Vérifie si la visite est aujourd'hui
  bool get isAujourdhui {
    final now = DateTime.now();
    return dateVisite.year == now.year &&
        dateVisite.month == now.month &&
        dateVisite.day == now.day;
  }

  /// Vérifie si la visite est dans le futur
  bool get isFuture {
    return dateVisite.isAfter(DateTime.now());
  }

  /// Nom du membre sûr pour l'UI
  String get displayMembreNom => membreNom ?? 'Membre inconnu';

  /// Nom du berger sûr pour l'UI
  String get displayBergerNom => bergerNom ?? 'Berger inconnu';

  /// Adresse sûre pour l'UI
  String get displayAdresse =>
      adresse.isNotEmpty ? adresse : 'Adresse non précisée';

  /// Motif sûr pour l'UI
  String get displayMotif => motif.isNotEmpty ? motif : 'Visite pastorale';

  /// Notes sûres pour l'UI
  String get displayNotes => notes.isNotEmpty ? notes : 'Aucune note';

  /// Date formatée pour affichage
  String get displayDate {
    final now = DateTime.now();
    final diff = dateVisite.difference(now).inDays;

    if (isAujourdhui) return 'Aujourd\'hui';
    if (diff == 1) return 'Demain';
    if (diff == -1) return 'Hier';

    return '${dateVisite.day.toString().padLeft(2, '0')}/'
        '${dateVisite.month.toString().padLeft(2, '0')}/'
        '${dateVisite.year}';
  }

  /// Heure formatée
  String get displayHeure {
    return '${dateVisite.hour.toString().padLeft(2, '0')}:${dateVisite.minute.toString().padLeft(2, '0')}';
  }

  /// Couleur associée au statut pour l'UI
  Color statutColor(BuildContext context) {
    switch (statut) {
      case StatutVisite.planifiee:
        return isEnRetard ? context.colors.errorText : context.colors.warningText;
      case StatutVisite.effectuee:
        return context.colors.successText;
      case StatutVisite.annulee:
        return context.colors.textTertiary;
    }
  }

  /// Libellé du statut pour l'UI
  String get statutLabel {
    switch (statut) {
      case StatutVisite.planifiee:
        return isEnRetard ? 'En retard' : 'Planifiée';
      case StatutVisite.effectuee:
        return 'Effectuée';
      case StatutVisite.annulee:
        return 'Annulée';
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PARSING DÉFENSIF - Helpers
  // ─────────────────────────────────────────────────────────────────────────────

  static StatutVisite _parseStatut(String? value) {
    const map = {
      'planifiee': StatutVisite.planifiee,
      'effectuee': StatutVisite.effectuee,
      'annulee': StatutVisite.annulee,
    };
    return map[value?.toLowerCase()] ?? StatutVisite.planifiee;
  }

  static String _parseString(dynamic value, {required String defaultValue}) {
    if (value == null) return defaultValue;
    if (value is String) return value.trim();
    return value.toString();
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// MEMBRE À VISITER - Priorisation défensive
/// ═══════════════════════════════════════════════════════════════════════════════

@freezed
class MembreAVisiter with _$MembreAVisiter {
  const factory MembreAVisiter({
    required String id,
    required String nom,
    String? prenom,
    DateTime? derniereVisite,
    @Default('À visiter') String raison,
    @Default(PrioriteVisite.moyenne) PrioriteVisite priorite,
    @Default('') String telephone,
    @Default('') String adresse,
    @Default(0) int joursEcoules,
  }) = _MembreAVisiter;

  const MembreAVisiter._();

  factory MembreAVisiter.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    if (id == null || id.isEmpty) {
      throw FormatException('MembreAVisiter: id est null', json);
    }

    final nom = json['nom'] as String? ?? '';
    final prenom = json['prenom'] as String? ?? '';
    final fullNom = '$prenom $nom'.trim();

    // Parsing de la priorité
    final prioriteStr = json['priorite'] as String? ?? 'moyenne';
    final priorite = _parsePriorite(prioriteStr);

    // Parsing des jours écoulés
    final joursEcoulesRaw = json['jours_ecoules'];
    final int joursEcoules;
    if (joursEcoulesRaw is int) {
      joursEcoules = joursEcoulesRaw;
    } else if (joursEcoulesRaw is String) {
      joursEcoules = int.tryParse(joursEcoulesRaw) ?? 0;
    } else {
      joursEcoules = 0;
    }

    return MembreAVisiter(
      id: id,
      nom: fullNom.isNotEmpty ? fullNom : 'Membre sans nom',
      prenom: prenom.isNotEmpty ? prenom : null,
      derniereVisite: VisitePastorale._parseDateTime(json['derniere_visite']),
      raison: VisitePastorale._parseString(
        json['raison'],
        defaultValue: 'À visiter',
      ),
      priorite: priorite,
      telephone: VisitePastorale._parseString(
        json['telephone'],
        defaultValue: '',
      ),
      adresse: VisitePastorale._parseString(json['adresse'], defaultValue: ''),
      joursEcoules: joursEcoules,
    );
  }

  /// Nom complet sûr
  String get displayNom => nom.isNotEmpty ? nom : 'Membre inconnu';

  /// Téléphone sûr
  String get displayTelephone =>
      telephone.isNotEmpty ? telephone : 'Non renseigné';

  /// Adresse sûre
  String get displayAdresse =>
      adresse.isNotEmpty ? adresse : 'Adresse non précisée';

  /// Texte descriptif de la dernière visite
  String get displayDerniereVisite {
    if (derniereVisite == null) return 'Jamais visité';
    if (joursEcoules >= 9999) return 'Jamais visité';
    if (joursEcoules == 0) return 'Visité aujourd\'hui';
    if (joursEcoules == 1) return 'Visité hier';
    return 'Dernière visite il y a $joursEcoules jours';
  }

  /// Couleur associée à la priorité
  Color prioriteColor(BuildContext context) {
    switch (priorite) {
      case PrioriteVisite.haute:
        return context.colors.errorText;
      case PrioriteVisite.moyenne:
        return context.colors.warningText;
      case PrioriteVisite.basse:
        return context.colors.infoText;
    }
  }

  /// Label de la priorité
  String get prioriteLabel {
    switch (priorite) {
      case PrioriteVisite.haute:
        return 'Haute priorité';
      case PrioriteVisite.moyenne:
        return 'Priorité moyenne';
      case PrioriteVisite.basse:
        return 'Priorité basse';
    }
  }

  static PrioriteVisite _parsePriorite(String? value) {
    const map = {
      'haute': PrioriteVisite.haute,
      'moyenne': PrioriteVisite.moyenne,
      'basse': PrioriteVisite.basse,
    };
    return map[value?.toLowerCase()] ?? PrioriteVisite.moyenne;
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// STATS VISITES - Agrégation sûre
/// ═══════════════════════════════════════════════════════════════════════════════

@freezed
class VisitesStats with _$VisitesStats {
  const factory VisitesStats({
    @Default(0) int planifiees,
    @Default(0) int effectuees,
    @Default(0) int annulees,
    @Default(0) int enRetard,
    @Default(0) int aVenir,
  }) = _VisitesStats;

  const VisitesStats._();

  factory VisitesStats.fromJson(Map<String, dynamic> json) {
    return VisitesStats(
      planifiees: json['planifiees'] as int? ?? 0,
      effectuees: json['effectuees'] as int? ?? 0,
      annulees: json['annulees'] as int? ?? 0,
      enRetard: json['en_retard'] as int? ?? 0,
      aVenir: json['a_venir'] as int? ?? 0,
    );
  }

  int get total => planifiees + effectuees + annulees;
}