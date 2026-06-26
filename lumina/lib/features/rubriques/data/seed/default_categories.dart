import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/enums/category_type.dart';

/// Données de seed pour les catégories prédéfinies
///
/// Contexte baptiste africain francophone avec catégories standards
/// Hiérarchie: Catégories racines → Sous-catégories → Détails
class DefaultCategoriesData {
  /// Génère toutes les catégories par défaut pour une église
  static List<TransactionCategory> getAllCategories(String churchId) {
    return [
      ...getIncomeCategories(churchId),
      ...getExpenseCategories(churchId),
    ];
  }

  /// Catégories de REVENUS
  static List<TransactionCategory> getIncomeCategories(String churchId) {
    final categories = <TransactionCategory>[];

    // === DÎMES ET OFFRANDES ===
    final dimesRoot = _createCategory(
      churchId: churchId,
      name: 'Dîmes et Offrandes',
      type: CategoryType.income,
      icon: 'volunteer_activism',
      color: '#4CAF50',
      order: 1,
    );
    categories.add(dimesRoot);

    categories.addAll([
      _createSubCategory(
        parentId: dimesRoot.id,
        churchId: churchId,
        name: 'Dîmes Mensuelles',
        icon: 'calendar_month',
        order: 1,
      ),
      _createSubCategory(
        parentId: dimesRoot.id,
        churchId: churchId,
        name: 'Dîmes par Anticipation',
        icon: 'fast_forward',
        order: 2,
      ),
      _createSubCategory(
        parentId: dimesRoot.id,
        churchId: churchId,
        name: 'Offrandes de Culte',
        icon: 'church',
        order: 3,
      ),
      _createSubCategory(
        parentId: dimesRoot.id,
        churchId: churchId,
        name: 'Offrandes Spéciales',
        icon: 'card_giftcard',
        order: 4,
      ),
      _createSubCategory(
        parentId: dimesRoot.id,
        churchId: churchId,
        name: 'Offrandes de Première Gerbe',
        icon: 'eco',
        order: 5,
      ),
      _createSubCategory(
        parentId: dimesRoot.id,
        churchId: churchId,
        name: 'Actions de Grâce',
        icon: 'celebration',
        order: 6,
      ),
    ]);

    // === DONS ET LIBÉRALITÉS ===
    final donsRoot = _createCategory(
      churchId: churchId,
      name: 'Dons et Libéralités',
      type: CategoryType.income,
      icon: 'redeem',
      color: '#FFC107',
      order: 2,
    );
    categories.add(donsRoot);

    categories.addAll([
      _createSubCategory(
        parentId: donsRoot.id,
        churchId: churchId,
        name: 'Dons Ponctuels',
        icon: 'attach_money',
        order: 1,
      ),
      _createSubCategory(
        parentId: donsRoot.id,
        churchId: churchId,
        name: 'Dons Récurrents',
        icon: 'autorenew',
        order: 2,
      ),
      _createSubCategory(
        parentId: donsRoot.id,
        churchId: churchId,
        name: 'Levées de Fonds',
        icon: 'campaign',
        order: 3,
      ),
      _createSubCategory(
        parentId: donsRoot.id,
        churchId: churchId,
        name: 'Legs et Héritages',
        icon: 'account_balance',
        order: 4,
      ),
    ]);

    // === PROJETS ET CONSTRUCTION ===
    final projetsRoot = _createCategory(
      churchId: churchId,
      name: 'Projets et Construction',
      type: CategoryType.income,
      icon: 'construction',
      color: '#FF9800',
      order: 3,
    );
    categories.add(projetsRoot);

    categories.addAll([
      _createSubCategory(
        parentId: projetsRoot.id,
        churchId: churchId,
        name: 'Construction Temple',
        icon: 'domain',
        order: 1,
      ),
      _createSubCategory(
        parentId: projetsRoot.id,
        churchId: churchId,
        name: 'Rénovations',
        icon: 'build',
        order: 2,
      ),
      _createSubCategory(
        parentId: projetsRoot.id,
        churchId: churchId,
        name: 'Équipements',
        icon: 'devices',
        order: 3,
      ),
    ]);

    // === ÉVÉNEMENTS ===
    final eventsRoot = _createCategory(
      churchId: churchId,
      name: 'Événements Spéciaux',
      type: CategoryType.income,
      icon: 'event',
      color: '#2196F3',
      order: 4,
    );
    categories.add(eventsRoot);

    categories.addAll([
      _createSubCategory(
        parentId: eventsRoot.id,
        churchId: churchId,
        name: 'Conventions',
        icon: 'groups',
        order: 1,
      ),
      _createSubCategory(
        parentId: eventsRoot.id,
        churchId: churchId,
        name: 'Retraites Spirituelles',
        icon: 'nature_people',
        order: 2,
      ),
      _createSubCategory(
        parentId: eventsRoot.id,
        churchId: churchId,
        name: 'Séminaires/Formations',
        icon: 'school',
        order: 3,
      ),
      _createSubCategory(
        parentId: eventsRoot.id,
        churchId: churchId,
        name: 'Événements Jeunesse',
        icon: 'celebration',
        order: 4,
      ),
    ]);

    // === AUTRES REVENUS ===
    final autresRoot = _createCategory(
      churchId: churchId,
      name: 'Autres Revenus',
      type: CategoryType.income,
      icon: 'more_horiz',
      color: '#9C27B0',
      order: 5,
    );
    categories.add(autresRoot);

    categories.addAll([
      _createSubCategory(
        parentId: autresRoot.id,
        churchId: churchId,
        name: 'Locations Salles',
        icon: 'meeting_room',
        order: 1,
      ),
      _createSubCategory(
        parentId: autresRoot.id,
        churchId: churchId,
        name: 'Vente Matériel',
        icon: 'store',
        order: 2,
      ),
      _createSubCategory(
        parentId: autresRoot.id,
        churchId: churchId,
        name: 'Intérêts Bancaires',
        icon: 'savings',
        order: 3,
      ),
    ]);

    return categories;
  }

  /// Catégories de DÉPENSES
  static List<TransactionCategory> getExpenseCategories(String churchId) {
    final categories = <TransactionCategory>[];

    // === PERSONNEL ===
    final personnelRoot = _createCategory(
      churchId: churchId,
      name: 'Personnel',
      type: CategoryType.expense,
      icon: 'badge',
      color: '#F44336',
      order: 1,
    );
    categories.add(personnelRoot);

    categories.addAll([
      _createSubCategory(
        parentId: personnelRoot.id,
        churchId: churchId,
        name: 'Salaires Pasteurs',
        icon: 'person',
        order: 1,
      ),
      _createSubCategory(
        parentId: personnelRoot.id,
        churchId: churchId,
        name: 'Salaires Personnel Administratif',
        icon: 'admin_panel_settings',
        order: 2,
      ),
      _createSubCategory(
        parentId: personnelRoot.id,
        churchId: churchId,
        name: 'Allocations Évangélistes',
        icon: 'hike',
        order: 3,
      ),
      _createSubCategory(
        parentId: personnelRoot.id,
        churchId: churchId,
        name: 'Cotisations Sociales',
        icon: 'health_and_safety',
        order: 4,
      ),
      _createSubCategory(
        parentId: personnelRoot.id,
        churchId: churchId,
        name: 'Formations Personnel',
        icon: 'school',
        order: 5,
      ),
    ]);

    // === BÂTIMENTS ET ENTRETIEN ===
    final batimentsRoot = _createCategory(
      churchId: churchId,
      name: 'Bâtiments et Entretien',
      type: CategoryType.expense,
      icon: 'home_repair_service',
      color: '#FF5722',
      order: 2,
    );
    categories.add(batimentsRoot);

    categories.addAll([
      _createSubCategory(
        parentId: batimentsRoot.id,
        churchId: churchId,
        name: 'Loyer',
        icon: 'home',
        order: 1,
      ),
      _createSubCategory(
        parentId: batimentsRoot.id,
        churchId: churchId,
        name: 'Électricité',
        icon: 'bolt',
        order: 2,
      ),
      _createSubCategory(
        parentId: batimentsRoot.id,
        churchId: churchId,
        name: 'Eau',
        icon: 'water_drop',
        order: 3,
      ),
      _createSubCategory(
        parentId: batimentsRoot.id,
        churchId: churchId,
        name: 'Nettoyage',
        icon: 'cleaning_services',
        order: 4,
      ),
      _createSubCategory(
        parentId: batimentsRoot.id,
        churchId: churchId,
        name: 'Réparations',
        icon: 'build_circle',
        order: 5,
      ),
      _createSubCategory(
        parentId: batimentsRoot.id,
        churchId: churchId,
        name: 'Sécurité',
        icon: 'security',
        order: 6,
      ),
    ]);

    // === MINISTÈRES ET ACTIVITÉS ===
    final ministeresRoot = _createCategory(
      churchId: churchId,
      name: 'Départements et Activités',
      type: CategoryType.expense,
      icon: 'groups_2',
      color: '#9C27B0',
      order: 3,
    );
    categories.add(ministeresRoot);

    categories.addAll([
      _createSubCategory(
        parentId: ministeresRoot.id,
        churchId: churchId,
        name: 'Évangélisation',
        icon: 'campaign',
        order: 1,
      ),
      _createSubCategory(
        parentId: ministeresRoot.id,
        churchId: churchId,
        name: 'Jeunesse',
        icon: 'people',
        order: 2,
      ),
      _createSubCategory(
        parentId: ministeresRoot.id,
        churchId: churchId,
        name: 'Enfants (École du Dimanche)',
        icon: 'child_care',
        order: 3,
      ),
      _createSubCategory(
        parentId: ministeresRoot.id,
        churchId: churchId,
        name: 'Femmes',
        icon: 'wc',
        order: 4,
      ),
      _createSubCategory(
        parentId: ministeresRoot.id,
        churchId: churchId,
        name: 'Hommes',
        icon: 'man',
        order: 5,
      ),
      _createSubCategory(
        parentId: ministeresRoot.id,
        churchId: churchId,
        name: 'Cellules de Maison',
        icon: 'home_work',
        order: 6,
      ),
      _createSubCategory(
        parentId: ministeresRoot.id,
        churchId: churchId,
        name: 'Louange et Adoration',
        icon: 'music_note',
        order: 7,
      ),
    ]);

    // === SOCIAL ET SOLIDARITÉ ===
    final socialRoot = _createCategory(
      churchId: churchId,
      name: 'Social et Solidarité',
      type: CategoryType.expense,
      icon: 'favorite',
      color: '#E91E63',
      order: 4,
    );
    categories.add(socialRoot);

    categories.addAll([
      _createSubCategory(
        parentId: socialRoot.id,
        churchId: churchId,
        name: 'Aide aux Nécessiteux',
        icon: 'volunteer_activism',
        order: 1,
      ),
      _createSubCategory(
        parentId: socialRoot.id,
        churchId: churchId,
        name: 'Visites Malades',
        icon: 'local_hospital',
        order: 2,
      ),
      _createSubCategory(
        parentId: socialRoot.id,
        churchId: churchId,
        name: 'Funérailles',
        icon: 'church',
        order: 3,
      ),
      _createSubCategory(
        parentId: socialRoot.id,
        churchId: churchId,
        name: 'Mariages',
        icon: 'favorite',
        order: 4,
      ),
    ]);

    // === COMMUNICATION ET MÉDIAS ===
    final mediaRoot = _createCategory(
      churchId: churchId,
      name: 'Communication et Médias',
      type: CategoryType.expense,
      icon: 'perm_media',
      color: '#00BCD4',
      order: 5,
    );
    categories.add(mediaRoot);

    categories.addAll([
      _createSubCategory(
        parentId: mediaRoot.id,
        churchId: churchId,
        name: 'Internet et Téléphone',
        icon: 'wifi',
        order: 1,
      ),
      _createSubCategory(
        parentId: mediaRoot.id,
        churchId: churchId,
        name: 'Équipements Sono/Vidéo',
        icon: 'videocam',
        order: 2,
      ),
      _createSubCategory(
        parentId: mediaRoot.id,
        churchId: churchId,
        name: 'Diffusions en Direct',
        icon: 'broadcast_on_personal',
        order: 3,
      ),
      _createSubCategory(
        parentId: mediaRoot.id,
        churchId: churchId,
        name: 'Site Web et Réseaux Sociaux',
        icon: 'language',
        order: 4,
      ),
      _createSubCategory(
        parentId: mediaRoot.id,
        churchId: churchId,
        name: 'Impression et Publications',
        icon: 'print',
        order: 5,
      ),
    ]);

    // === ADMINISTRATION ===
    final adminRoot = _createCategory(
      churchId: churchId,
      name: 'Administration',
      type: CategoryType.expense,
      icon: 'business_center',
      color: '#607D8B',
      order: 6,
    );
    categories.add(adminRoot);

    categories.addAll([
      _createSubCategory(
        parentId: adminRoot.id,
        churchId: churchId,
        name: 'Fournitures de Bureau',
        icon: 'inventory_2',
        order: 1,
      ),
      _createSubCategory(
        parentId: adminRoot.id,
        churchId: churchId,
        name: 'Frais Bancaires',
        icon: 'account_balance',
        order: 2,
      ),
      _createSubCategory(
        parentId: adminRoot.id,
        churchId: churchId,
        name: 'Assurances',
        icon: 'shield',
        order: 3,
      ),
      _createSubCategory(
        parentId: adminRoot.id,
        churchId: churchId,
        name: 'Frais Juridiques',
        icon: 'gavel',
        order: 4,
      ),
      _createSubCategory(
        parentId: adminRoot.id,
        churchId: churchId,
        name: 'Transport et Déplacements',
        icon: 'directions_car',
        order: 5,
      ),
    ]);

    // === MISSIONS ET PARTENARIATS ===
    final missionsRoot = _createCategory(
      churchId: churchId,
      name: 'Missions et Partenariats',
      type: CategoryType.expense,
      icon: 'public',
      color: '#795548',
      order: 7,
    );
    categories.add(missionsRoot);

    categories.addAll([
      _createSubCategory(
        parentId: missionsRoot.id,
        churchId: churchId,
        name: 'Soutien Missionnaires',
        icon: 'flight_takeoff',
        order: 1,
      ),
      _createSubCategory(
        parentId: missionsRoot.id,
        churchId: churchId,
        name: 'Œuvres et ONG Partenaires',
        icon: 'handshake',
        order: 2,
      ),
      _createSubCategory(
        parentId: missionsRoot.id,
        churchId: churchId,
        name: 'Fédération/Convention',
        icon: 'account_tree',
        order: 3,
      ),
    ]);

    return categories;
  }

  /// Helper: Créer une catégorie racine
  static TransactionCategory _createCategory({
    required String churchId,
    required String name,
    required CategoryType type,
    required String icon,
    required String color,
    required int order,
  }) {
    return TransactionCategory(
      id: '${DateTime.now().millisecondsSinceEpoch}_$name',
      churchId: churchId,
      name: name,
      type: type,
      iconName: icon,
      color: color,
      sortOrder: order,
      isBudgetable: true,
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  /// Helper: Créer une sous-catégorie
  static TransactionCategory _createSubCategory({
    required String parentId,
    required String churchId,
    required String name,
    required String icon,
    required int order,
  }) {
    return TransactionCategory(
      id: '${DateTime.now().millisecondsSinceEpoch}_${parentId}_$name',
      churchId: churchId,
      name: name,
      type: CategoryType.income, // Sera hérité du parent dans la logique
      parentId: parentId,
      iconName: icon,
      color: '#9E9E9E', // Couleur neutre pour sous-catégories
      sortOrder: order,
      isBudgetable: true,
      isActive: true,
      createdAt: DateTime.now(),
    );
  }
}