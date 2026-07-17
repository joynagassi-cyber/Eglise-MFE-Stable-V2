// lib/core/data/local/isar_service.dart
// Service centralisÃ© pour la base de donnÃ©es locale Isar

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina/features/membres/data/models/member_model.dart';
import 'package:lumina/features/membres/domain/entities/enums/enums.dart';
import 'package:lumina/features/groups/domain/entities/group.dart';
import 'package:lumina/features/groups/domain/entities/group_membership.dart';

import 'package:lumina/features/finance/data/models/finance_transaction_model.dart';
import 'package:lumina/features/finance/data/models/financial_account_model.dart';
import 'package:lumina/features/churches/data/models/church_model.dart';
import 'package:lumina/features/churches/data/models/federation_model.dart';
import 'package:lumina/features/auth/data/models/role_model.dart';
import 'package:lumina/features/auth/data/models/session_model.dart';
import 'package:lumina/features/sacraments/data/models/sacrament_model.dart';
import 'package:lumina/features/events/data/models/event_model.dart';
import 'package:lumina/features/annonces/data/models/annonce_model.dart';
import 'package:lumina/features/bergers/data/models/shepherd_model.dart';
import 'package:lumina/features/bergers/data/models/pastoral_visit_model.dart';
import 'package:lumina/features/finance/data/models/budget_model.dart';
import 'package:lumina/features/finance/domain/entities/enums/budget_period.dart';
import 'package:lumina/features/finance/data/models/recurring_transaction_model.dart';
import 'package:lumina/features/rubriques/data/models/category_model.dart';
import 'package:lumina/core/data/models/sync_item_model.dart';
import 'package:lumina/core/data/models/sync_operation_model.dart';
import 'package:lumina/features/notifications/data/models/notification_model.dart';
import 'package:lumina/features/messaging/data/models/chat_message_model.dart';
import 'package:lumina/features/groups/data/models/group_attendance_model.dart';
import 'package:lumina/features/groups/data/models/member_transfer_request_model.dart';
import 'package:lumina/features/groups/data/models/group_model.dart';
import 'package:lumina/features/groups/data/models/group_membership_model.dart';
import 'package:lumina/features/celebrations/data/models/church_service_model.dart';
import 'package:lumina/features/celebrations/data/models/service_attendance_model.dart';
import 'package:lumina/features/donors/data/models/donor_model.dart';
import 'package:lumina/features/donors/data/models/donation_model.dart';
import 'package:lumina/features/tasks/data/models/task_model.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:lumina/features/groups/chorale/data/models/sheet_music_model.dart';
import 'package:lumina/features/groups/chorale/data/models/rehearsal_model.dart';
import 'package:lumina/features/groups/hommes/data/models/group_project_model.dart';
import 'package:lumina/features/groups/hommes/data/models/mentorship_pair_model.dart';
import 'package:lumina/features/groups/femmes/data/models/training_model.dart';
import 'package:lumina/features/groups/femmes/data/models/mutual_aid_request_model.dart';
import 'package:lumina/features/groups/jeunesse/data/models/camp_model.dart';
import 'package:lumina/features/groups/jeunesse/data/models/discipleship_program_model.dart';
import 'package:lumina/features/groups/enfants/data/models/child_safety_card_model.dart';
import 'package:lumina/features/groups/enfants/data/models/children_program_model.dart';
import 'package:lumina/features/groups/enfants/data/models/pedagogic_resource_model.dart';
import 'package:lumina/features/groups/intercession/data/models/prayer_vigil_model.dart';
import 'package:lumina/features/groups/intercession/data/models/permanent_prayer_subject_model.dart';

import 'package:lumina/features/audit/data/models/audit_log_model.dart';
import 'package:lumina/features/vie-spirituelle/data/models/jalon_spirituel_model.dart';
import 'package:lumina/core/data/models/sync_lock_model.dart';
import 'package:lumina/core/data/models/local_session_model.dart';
import 'package:lumina/core/data/models/local_profile_model.dart';
import 'package:lumina/core/data/models/local_user_context_model.dart';

part 'isar_service.g.dart';

@Riverpod(keepAlive: true)
IsarService isarService(Ref ref) {
  throw UnimplementedError('IsarService must be initialized in main.dart');
}

class IsarService {
  final Isar? _isar;

  IsarService(this._isar);

  Isar get db => _isar!;
  bool get isReady => _isar != null;

  // Getters de collections explicites pour Ã©viter les erreurs de type et les getters manquants
  IsarCollection<MemberModel> get memberModels =>
      _isar!.collection<MemberModel>();
  IsarCollection<FinanceTransactionModel> get financeTransactionModels =>
      _isar!.collection<FinanceTransactionModel>();
  IsarCollection<FinancialAccountModel> get financialAccountModels =>
      _isar!.collection<FinancialAccountModel>();
  IsarCollection<BudgetModel> get budgetModels =>
      _isar!.collection<BudgetModel>();
  IsarCollection<RecurringTransactionModel> get recurringTransactionModels =>
      _isar!.collection<RecurringTransactionModel>();
  IsarCollection<SyncItemModel> get syncItemModels =>
      _isar!.collection<SyncItemModel>();
  IsarCollection<SyncOperationModel> get syncOperationModels =>
      _isar!.collection<SyncOperationModel>();
  IsarCollection<SacramentModel> get sacramentModels =>
      _isar!.collection<SacramentModel>();
  IsarCollection<DonorModel> get donorModels => _isar!.collection<DonorModel>();
  IsarCollection<DonationModel> get donationModels =>
      _isar!.collection<DonationModel>();
  IsarCollection<EventModel> get eventModels => _isar!.collection<EventModel>();
  IsarCollection<AnnonceModel> get annonceModels =>
      _isar!.collection<AnnonceModel>();
  IsarCollection<ShepherdModel> get shepherdModels =>
      _isar!.collection<ShepherdModel>();
  IsarCollection<PastoralVisitModel> get pastoralVisitModels =>
      _isar!.collection<PastoralVisitModel>();
  IsarCollection<CategoryModel> get categoryModels =>
      _isar!.collection<CategoryModel>();
  IsarCollection<NotificationModel> get notificationModels =>
      _isar!.collection<NotificationModel>();
  IsarCollection<GroupModel> get groupModels => _isar!.collection<GroupModel>();
  IsarCollection<GroupMembershipModel> get groupMembershipModels =>
      _isar!.collection<GroupMembershipModel>();
  IsarCollection<GroupAttendanceModel> get groupAttendanceModels =>
      _isar!.collection<GroupAttendanceModel>();
  IsarCollection<MemberTransferRequestModel> get memberTransferRequestModels =>
      _isar!.collection<MemberTransferRequestModel>();
  IsarCollection<ChurchServiceModel> get churchServiceModels =>
      _isar!.collection<ChurchServiceModel>();
  IsarCollection<ServiceAttendanceModel> get serviceAttendanceModels =>
      _isar!.collection<ServiceAttendanceModel>();
  IsarCollection<TaskModel> get taskModels => _isar!.collection<TaskModel>();
  IsarCollection<ChurchModel> get churchModels =>
      _isar!.collection<ChurchModel>();
  IsarCollection<ChatMessageModel> get chatMessageModels =>
      _isar!.collection<ChatMessageModel>();
  IsarCollection<FederationModel> get federationModels =>
      _isar!.collection<FederationModel>();
  IsarCollection<RoleModel> get roleModels => _isar!.collection<RoleModel>();
  IsarCollection<SessionModel> get sessionModels =>
      _isar!.collection<SessionModel>();
  IsarCollection<BibleBookModel> get bibleBookModels =>
      _isar!.collection<BibleBookModel>();
  IsarCollection<BibleChapterModel> get bibleChapterModels =>
      _isar!.collection<BibleChapterModel>();
  IsarCollection<BibleVerseModel> get bibleVerseModels =>
      _isar!.collection<BibleVerseModel>();
  IsarCollection<BibleAnnotationModel> get bibleAnnotationModels =>
      _isar!.collection<BibleAnnotationModel>();
  IsarCollection<BibleReadingPlanModel> get bibleReadingPlanModels =>
      _isar!.collection<BibleReadingPlanModel>();
  IsarCollection<BiblePlanProgressModel> get biblePlanProgressModels =>
      _isar!.collection<BiblePlanProgressModel>();
  IsarCollection<BibleBookmarkModel> get bibleBookmarkModels =>
      _isar!.collection<BibleBookmarkModel>();
  IsarCollection<BibleRewardModel> get bibleRewardModels =>
      _isar!.collection<BibleRewardModel>();
  IsarCollection<BibleSearchHistoryModel> get bibleSearchHistoryModels =>
      _isar!.collection<BibleSearchHistoryModel>();
  IsarCollection<BibleReadingStatModel> get bibleReadingStatModels =>
      _isar!.collection<BibleReadingStatModel>();
  IsarCollection<SheetMusicModel> get sheetMusicModels =>
      _isar!.collection<SheetMusicModel>();
  IsarCollection<RehearsalModel> get rehearsalModels =>
      _isar!.collection<RehearsalModel>();
  IsarCollection<GroupProjectModel> get groupProjectModels =>
      _isar!.collection<GroupProjectModel>();
  IsarCollection<MentorshipPairModel> get mentorshipPairModels =>
      _isar!.collection<MentorshipPairModel>();
  IsarCollection<TrainingModel> get trainingModels =>
      _isar!.collection<TrainingModel>();
  IsarCollection<MutualAidRequestModel> get mutualAidRequestModels =>
      _isar!.collection<MutualAidRequestModel>();
  IsarCollection<CampModel> get campModels => _isar!.collection<CampModel>();
  IsarCollection<DiscipleshipProgramModel> get discipleshipProgramModels =>
      _isar!.collection<DiscipleshipProgramModel>();
  IsarCollection<ChildSafetyCardModel> get childSafetyCardModels =>
      _isar!.collection<ChildSafetyCardModel>();
  IsarCollection<ChildrenProgramModel> get childrenProgramModels =>
      _isar!.collection<ChildrenProgramModel>();
  IsarCollection<PedagogicResourceModel> get pedagogicResourceModels =>
      _isar!.collection<PedagogicResourceModel>();
  IsarCollection<PrayerVigilModel> get prayerVigilModels =>
      _isar!.collection<PrayerVigilModel>();
  IsarCollection<PermanentPrayerSubjectModel>
      get permanentPrayerSubjectModels =>
          _isar!.collection<PermanentPrayerSubjectModel>();
  IsarCollection<SyncLockModel> get syncLockModels =>
      _isar!.collection<SyncLockModel>();
  IsarCollection<JalonSpirituelModel> get jalonSpirituelModels =>
      _isar!.collection<JalonSpirituelModel>();
  IsarCollection<MembreJalonModel> get membreJalonModels =>
      _isar!.collection<MembreJalonModel>();
  IsarCollection<AuditLogModel> get auditLogModels =>
      _isar!.collection<AuditLogModel>();
  IsarCollection<LocalSessionModel> get localSessionModels =>
      _isar!.collection<LocalSessionModel>();
  IsarCollection<LocalProfileModel> get localProfileModels =>
      _isar!.collection<LocalProfileModel>();
  IsarCollection<LocalUserContextModel> get localUserContextModels =>
      _isar!.collection<LocalUserContextModel>();


  static Future<IsarService> init() async {
    try {
      if (kIsWeb) {
        return IsarService(null);
      }

      String? path;
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        path = dir.path;
      }

      final isar = await Isar.open(
        [
          MemberModelSchema,
          FinanceTransactionModelSchema,
          FinancialAccountModelSchema,
          ChurchModelSchema,
          FederationModelSchema,
          RoleModelSchema,
          SessionModelSchema,
          SacramentModelSchema,
          EventModelSchema,
          AnnonceModelSchema,
          ShepherdModelSchema,
          PastoralVisitModelSchema,
          BudgetModelSchema,
          CategoryModelSchema,
          SyncItemModelSchema,
          SyncOperationModelSchema,
          NotificationModelSchema,
          GroupModelSchema,
          GroupMembershipModelSchema,
          GroupAttendanceModelSchema,
          MemberTransferRequestModelSchema,
          ChurchServiceModelSchema,
          ServiceAttendanceModelSchema,
          DonorModelSchema,
          DonationModelSchema,
          TaskModelSchema,
          RecurringTransactionModelSchema,
          BibleBookModelSchema,
          BibleChapterModelSchema,
          BibleVerseModelSchema,
          BibleAnnotationModelSchema,
          BibleReadingPlanModelSchema,
          BiblePlanProgressModelSchema,
          BibleBookmarkModelSchema,
          BibleRewardModelSchema,
          BibleSearchHistoryModelSchema,
          BibleReadingStatModelSchema,
          ChatMessageModelSchema,
          SheetMusicModelSchema,
          RehearsalModelSchema,
          GroupProjectModelSchema,
          MentorshipPairModelSchema,
          TrainingModelSchema,
          MutualAidRequestModelSchema,
          CampModelSchema,
          DiscipleshipProgramModelSchema,
          ChildSafetyCardModelSchema,
          ChildrenProgramModelSchema,
          PedagogicResourceModelSchema,
          PrayerVigilModelSchema,
          PermanentPrayerSubjectModelSchema,
          SyncLockModelSchema,
          JalonSpirituelModelSchema,
          MembreJalonModelSchema,
          AuditLogModelSchema,
          LocalSessionModelSchema,
          LocalProfileModelSchema,
          LocalUserContextModelSchema,
        ],
        directory: path ?? '',
      );
      return IsarService(isar);
    } catch (e) {
      debugPrint('Isar initialization failed: $e');
      if (kIsWeb) {
        return IsarService(null);
      }
      rethrow;
    }
  }

  // Note: Encryption key management should be implemented if actual database encryption is enabled.
  // For now, Isar is opened without a key.

  Future<void> clearChurchSpecificData() async {
    if (_isar == null) return;
    await db.writeTxn(() async {
      await memberModels.clear();
      await financeTransactionModels.clear();
      await financialAccountModels.clear();
      await budgetModels.clear();
      await sacramentModels.clear();
      await donorModels.clear();
      await donationModels.clear();
      await eventModels.clear();
      await annonceModels.clear();
      await shepherdModels.clear();
      await pastoralVisitModels.clear();
      await categoryModels.clear();
      await notificationModels.clear();
      await groupModels.clear();
      await groupMembershipModels.clear();
      await groupAttendanceModels.clear();
      await memberTransferRequestModels.clear();
      await churchServiceModels.clear();
      await serviceAttendanceModels.clear();
      await taskModels.clear();
      await recurringTransactionModels.clear();
      await sheetMusicModels.clear();
      await rehearsalModels.clear();
      await groupProjectModels.clear();
      await mentorshipPairModels.clear();
      await trainingModels.clear();
      await mutualAidRequestModels.clear();
      await campModels.clear();
      await discipleshipProgramModels.clear();
      await childSafetyCardModels.clear();
      await childrenProgramModels.clear();
      await pedagogicResourceModels.clear();
      await prayerVigilModels.clear();
      await permanentPrayerSubjectModels.clear();
      await bibleAnnotationModels.clear();
      await bibleBookmarkModels.clear();
      await bibleReadingStatModels.clear();
      await bibleSearchHistoryModels.clear();
    });
  }

  // ===========================================================================
  // BASE OPERATIONS (ATOMIC & RAW)
  // ===========================================================================

  /// Sauvegarde gÃ©nÃ©rique atomique
  Future<void> save<T>(T item) async {
    if (_isar == null) return;
    await db.writeTxn(() async {
      await db.collection<T>().put(item);
    });
  }

  /// Sauvegarde brute (Ã  utiliser UNIQUEMENT Ã  l'intÃ©rieur d'une transaction existante)
  /// pour Ã©viter les Deadlocks.
  Future<void> putRaw<T>(T item) async {
    if (_isar == null) return;
    await db.collection<T>().put(item);
  }

  /// Sauvegarde de membre atomique
  Future<void> saveMember(MemberModel member) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putMemberRaw(member));
  }

  /// Sauvegarde de membre brute (sans transaction interne)
  Future<void> putMemberRaw(MemberModel member) async {
    if (_isar == null) return;
    await memberModels.put(member);
  }

  Future<int> countMembers() async {
    if (_isar == null) return 0;
    return memberModels.where().count();
  }

  Future<List<MemberModel>> searchMembers(
      String? churchId, String query) async {
    if (_isar == null) return [];
    final lowercaseQuery = query.toLowerCase();

    return memberModels
        .filter()
        .optional(churchId != null && churchId != '*',
            (q) => q.churchIdEqualTo(churchId!))
        .group((q) => q
            .firstNameContains(lowercaseQuery, caseSensitive: false)
            .or()
            .lastNameContains(lowercaseQuery, caseSensitive: false)
            .or()
            .phoneContains(lowercaseQuery)
            .or()
            .emailContains(lowercaseQuery, caseSensitive: false))
        .findAll();
  }

  Future<void> deleteMember(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => memberModels.delete(id));
  }

  Stream<List<MemberModel>> watchMembers({String? churchId}) {
    if (_isar == null) return const Stream.empty();
    final query = memberModels.where();
    if (churchId != null && churchId != '*') {
      return query.churchIdEqualTo(churchId).watch(fireImmediately: true);
    }
    return query.watch(fireImmediately: true);
  }

  Future<List<SacramentModel>> getSacraments() async {
    if (_isar == null) return [];
    return sacramentModels.where().findAll();
  }

  Future<List<SacramentModel>> searchSacraments(String query) async {
    if (_isar == null) return [];
    final lowercaseQuery = query.toLowerCase();
    return sacramentModels
        .filter()
        .memberFirstNameContains(lowercaseQuery, caseSensitive: false)
        .or()
        .memberLastNameContains(lowercaseQuery, caseSensitive: false)
        .or()
        .godfatherContains(lowercaseQuery, caseSensitive: false)
        .or()
        .godmotherContains(lowercaseQuery, caseSensitive: false)
        .or()
        .certificateNumberContains(lowercaseQuery, caseSensitive: false)
        .findAll();
  }

  Future<void> saveSacrament(SacramentModel sacrament) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putSacramentRaw(sacrament));
  }

  Future<void> putSacramentRaw(SacramentModel sacrament) async {
    if (_isar == null) return;
    await sacramentModels.put(sacrament);
  }

  Future<void> deleteSacrament(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await sacramentModels.delete(id));
  }

  Future<List<DonorModel>> searchDonors(String query) async {
    if (_isar == null) return [];
    final lowercaseQuery = query.toLowerCase();
    return donorModels
        .filter()
        .displayNameContains(lowercaseQuery, caseSensitive: false)
        .or()
        .firstNameContains(lowercaseQuery, caseSensitive: false)
        .or()
        .lastNameContains(lowercaseQuery, caseSensitive: false)
        .or()
        .organizationNameContains(lowercaseQuery, caseSensitive: false)
        .or()
        .emailContains(lowercaseQuery, caseSensitive: false)
        .findAll();
  }

  Future<void> saveDonor(DonorModel donor) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putDonorRaw(donor));
  }

  Future<void> putDonorRaw(DonorModel donor) async {
    if (_isar == null) return;
    await donorModels.put(donor);
  }

  Future<List<DonationModel>> searchDonations({
    String? donorId,
    String? query,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_isar == null) return [];
    return donationModels
        .filter()
        .optional(donorId != null, (q) => q.donorIdEqualTo(donorId!))
        .optional(query != null && query.isNotEmpty,
            (q) => q.notesContains(query!.toLowerCase(), caseSensitive: false))
        .optional(startDate != null,
            (q) => q.donationDateGreaterThan(startDate!, include: true))
        .optional(endDate != null,
            (q) => q.donationDateLessThan(endDate!, include: true))
        .findAll();
  }

  Future<void> saveDonation(DonationModel donation) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putDonationRaw(donation));
  }

  Future<void> putDonationRaw(DonationModel donation) async {
    if (_isar == null) return;
    await donationModels.put(donation);
  }

  Future<List<GroupModel>> searchGroups(String query) async {
    if (_isar == null) return [];
    final lowercaseQuery = query.toLowerCase();
    return groupModels
        .filter()
        .nameContains(lowercaseQuery, caseSensitive: false)
        .or()
        .locationContains(lowercaseQuery, caseSensitive: false)
        .findAll();
  }

  Future<List<PastoralVisitModel>> searchPastoralVisits(String query) async {
    if (_isar == null) return [];
    final lowercaseQuery = query.toLowerCase();
    return pastoralVisitModels
        .filter()
        .notesContains(lowercaseQuery, caseSensitive: false)
        .findAll();
  }

  Future<List<EventModel>> getEvents() async {
    if (_isar == null) return [];
    return eventModels.where().findAll();
  }

  Future<List<EventModel>> searchEvents(String query) async {
    if (_isar == null) return [];
    final lowercaseQuery = query.toLowerCase();
    return eventModels
        .filter()
        .titleContains(lowercaseQuery, caseSensitive: false)
        .or()
        .descriptionContains(lowercaseQuery, caseSensitive: false)
        .findAll();
  }

  Future<List<AnnonceModel>> searchAnnonces(String query) async {
    if (_isar == null) return [];
    final lowercaseQuery = query.toLowerCase();
    return annonceModels
        .filter()
        .titleContains(lowercaseQuery, caseSensitive: false)
        .or()
        .contentContains(lowercaseQuery, caseSensitive: false)
        .or()
        .summaryContains(lowercaseQuery, caseSensitive: false)
        .findAll();
  }

  Future<void> saveEvent(EventModel event) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putEventRaw(event));
  }

  Future<void> putEventRaw(EventModel event) async {
    if (_isar == null) return;
    await eventModels.put(event);
  }

  Future<void> deleteEvent(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await eventModels.delete(id));
  }

  Future<List<AnnonceModel>> getAnnonces() async {
    if (_isar == null) return [];
    return annonceModels.where().findAll();
  }

  Future<void> saveAnnonce(AnnonceModel annonce) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putAnnonceRaw(annonce));
  }

  Future<void> putAnnonceRaw(AnnonceModel annonce) async {
    if (_isar == null) return;
    await annonceModels.put(annonce);
  }

  Future<void> deleteAnnonce(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await annonceModels.delete(id));
  }

  Future<List<FinanceTransactionModel>> getFinanceTransactions() async {
    if (_isar == null) return [];
    return financeTransactionModels.where().findAll();
  }

  Future<void> saveFinanceTransaction(
      FinanceTransactionModel transaction) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putFinanceTransactionRaw(transaction));
  }

  Future<void> putFinanceTransactionRaw(
      FinanceTransactionModel transaction) async {
    if (_isar == null) return;
    await financeTransactionModels.put(transaction);
  }

  Future<void> deleteFinanceTransaction(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await financeTransactionModels.delete(id));
  }

  Stream<List<FinanceTransactionModel>> watchFinanceTransactions() {
    if (_isar == null) return const Stream.empty();
    return financeTransactionModels.where().watch(fireImmediately: true);
  }

  Future<List<FinancialAccountModel>> getFinancialAccounts() async {
    if (_isar == null) return [];
    return financialAccountModels.where().findAll();
  }

  Future<void> saveFinancialAccount(FinancialAccountModel account) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putFinancialAccountRaw(account));
  }

  Future<void> putFinancialAccountRaw(FinancialAccountModel account) async {
    if (_isar == null) return;
    await financialAccountModels.put(account);
  }

  Future<void> deleteFinancialAccount(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await financialAccountModels.delete(id));
  }

  Stream<List<FinancialAccountModel>> watchFinancialAccounts() {
    if (_isar == null) return const Stream.empty();
    return financialAccountModels.where().watch(fireImmediately: true);
  }

  Future<List<RecurringTransactionModel>> getRecurringTransactions() async {
    if (_isar == null) return [];
    return recurringTransactionModels.where().findAll();
  }

  Future<void> saveRecurringTransaction(
      RecurringTransactionModel recurring) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putRecurringTransactionRaw(recurring));
  }

  Future<void> putRecurringTransactionRaw(
      RecurringTransactionModel recurring) async {
    if (_isar == null) return;
    await recurringTransactionModels.put(recurring);
  }

  Future<void> deleteRecurringTransaction(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await recurringTransactionModels.delete(id));
  }

  Stream<List<RecurringTransactionModel>> watchRecurringTransactions() {
    if (_isar == null) return const Stream.empty();
    return recurringTransactionModels.where().watch(fireImmediately: true);
  }

  Future<List<FinanceTransactionModel>> searchTransactions({
    String? query,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? category,
    int offset = 0,
    int limit = 50,
  }) async {
    if (!isReady) return [];

    var queryBuilder = financeTransactionModels.filter();

    if (query != null && query.isNotEmpty) {
      queryBuilder =
          queryBuilder.descriptionContains(query, caseSensitive: false);
    }

    return queryBuilder
        .optional(
            startDate != null,
            (q) => q.dateGreaterThan(
                startDate!.subtract(const Duration(milliseconds: 1))))
        .optional(
            endDate != null,
            (q) =>
                q.dateLessThan(endDate!.add(const Duration(milliseconds: 1))))
        .optional(type != null, (q) => q.typeEqualTo(type!))
        .optional(category != null, (q) => q.categoryEqualTo(category!))
        .sortByDateDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  Future<double> getTotalIncome(DateTime start, DateTime end) async {
    if (_isar == null) return 0.0;
    final transactions = await financeTransactionModels
        .filter()
        .typeEqualTo('income')
        .dateBetween(start, end)
        .findAll();
    return transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  Future<double> getTotalExpense(DateTime start, DateTime end) async {
    if (_isar == null) return 0.0;
    final transactions = await financeTransactionModels
        .filter()
        .typeEqualTo('expense')
        .dateBetween(start, end)
        .findAll();
    return transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  Future<List<ShepherdModel>> getAllShepherds() async {
    if (_isar == null) return [];
    return shepherdModels.where().findAll();
  }

  Future<void> saveShepherd(ShepherdModel shepherd) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putShepherdRaw(shepherd));
  }

  Future<void> putShepherdRaw(ShepherdModel shepherd) async {
    if (_isar == null) return;
    await shepherdModels.put(shepherd);
  }

  Future<void> deleteShepherd(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await shepherdModels.delete(id));
  }

  Future<List<PastoralVisitModel>> getPastoralVisits(
      {String? shepherdId}) async {
    if (_isar == null) return [];
    if (shepherdId == null) {
      return pastoralVisitModels.where().findAll();
    }
    return pastoralVisitModels.filter().shepherdIdEqualTo(shepherdId).findAll();
  }

  Future<void> savePastoralVisit(PastoralVisitModel visit) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putPastoralVisitRaw(visit));
  }

  Future<void> putPastoralVisitRaw(PastoralVisitModel visit) async {
    if (_isar == null) return;
    await pastoralVisitModels.put(visit);
  }

  Future<List<BudgetModel>> getAllBudgets() async {
    if (_isar == null) return [];
    return budgetModels.where().findAll();
  }

  Future<BudgetModel?> getBudgetByBudgetId(String id) async {
    if (_isar == null) return null;
    return budgetModels.filter().idEqualTo(id).findFirst();
  }

  Future<void> saveBudget(BudgetModel budget) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putBudgetRaw(budget));
  }

  Future<void> putBudgetRaw(BudgetModel budget) async {
    if (_isar == null) return;
    await budgetModels.put(budget);
  }

  Future<void> deleteBudget(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await budgetModels.delete(id));
  }

  Future<List<CategoryModel>> getAllCategories() async {
    if (_isar == null) return [];
    return categoryModels.where().findAll();
  }

  Future<void> saveCategory(CategoryModel category) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putCategoryRaw(category));
  }

  Future<void> putCategoryRaw(CategoryModel category) async {
    if (_isar == null) return;
    await categoryModels.put(category);
  }

  Future<void> deleteCategory(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await categoryModels.delete(id));
  }

  Future<void> queueSyncItem(SyncItemModel item) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putSyncItemRaw(item));
  }

  Future<void> putSyncItemRaw(SyncItemModel item) async {
    if (_isar == null) return;
    await syncItemModels.put(item);
  }

  Future<void> deleteSyncItem(Id isarId) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await syncItemModels.delete(isarId));
  }

  Future<List<SyncItemModel>> getPendingSyncItems() async {
    if (_isar == null) return [];
    return syncItemModels
        .filter()
        .isProcessingEqualTo(false)
        .sortByCreatedAt()
        .findAll();
  }

  Future<void> markSyncItemProcessing(Id isarId, bool isProcessing) async {
    if (_isar == null) return;
    await db.writeTxn(() async {
      final item = await syncItemModels.get(isarId);
      if (item != null) {
        item.isProcessing = isProcessing;
        await putSyncItemRaw(item);
      }
    });
  }

  Future<List<NotificationModel>> getNotifications() async {
    if (_isar == null) return [];
    return notificationModels.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> saveNotification(NotificationModel notification) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await putNotificationRaw(notification));
  }

  Future<void> putNotificationRaw(NotificationModel notification) async {
    if (_isar == null) return;
    await notificationModels.put(notification);
  }

  Future<void> deleteNotification(int id) async {
    if (_isar == null) return;
    await db.writeTxn(() async => await notificationModels.delete(id));
  }

  // ===========================================================================
  // UPSERT FROM REMOTE â€” MÃ©thodes de Pull diffÃ©rentiel (SyncService)
  //
  // Chaque mÃ©thode applique une ligne JSON brute venue de Supabase
  // dans la collection Isar correspondante.
  // Pattern : on garde le jsonData complet pour les round-trips fiables.
  // Les champs indexÃ©s sont extraits pour les requÃªtes rapides.
  // ===========================================================================

  Future<void> upsertMemberFromRemote(Map<String, dynamic> row) async {
    if (_isar == null) return;
    final id = row['id']?.toString();
    if (id == null) return;

    await db.writeTxn(() async {
      final existing = await memberModels.filter().idEqualTo(id).findFirst();
      final model = existing ?? MemberModel();
      model
        ..id = id
        ..churchId = row['church_id']?.toString()
        ..userId = row['user_id']?.toString()
        ..firstName = row['first_name']?.toString()
        ..lastName = row['last_name']?.toString()
        ..gender = _parseEnum(row['gender'], Gender.values, Gender.other)
        ..status = _parseEnum(
            row['status'], MemberStatus.values, MemberStatus.active)
        ..primaryRole = _parseEnum(
            row['primary_role'], ChurchRoleType.values, ChurchRoleType.member)
        ..photoUrl = row['photo_url']?.toString()
        ..phone = row['phone']?.toString()
        ..email = row['email']?.toString()
        ..city = row['city']?.toString()
        ..updatedAt = _parseDateTime(row['updated_at'])
        ..version = (row['version'] as num?)?.toInt() ?? 1
        ..isDeleted = row['is_deleted'] as bool? ?? false
        ..lastSyncedAt = DateTime.now().toUtc()
        ..jsonData = jsonEncode(row);
      await memberModels.put(model);
    });
  }

  Future<void> upsertFinanceTransactionFromRemote(
      Map<String, dynamic> row) async {
    if (_isar == null) return;
    final id = row['id']?.toString();
    if (id == null) return;

    await db.writeTxn(() async {
      final existing =
          await financeTransactionModels.filter().idEqualTo(id).findFirst();
      final model = existing ?? FinanceTransactionModel();
      model
        ..id = id
        ..churchId = row['church_id']?.toString()
        ..date = _parseDateTime(row['date']) ?? DateTime.now()
        ..amount = (row['amount'] as num?)?.toDouble() ?? 0.0
        ..type = row['type']?.toString() ?? 'income'
        ..description = row['description']?.toString()
        ..category = row['category']?.toString() ?? 'Autre'
        ..accountId = row['account_id']?.toString() ?? ''
        ..updatedAt = _parseDateTime(row['updated_at'])
        ..version = (row['version'] as num?)?.toInt() ?? 1
        ..isDeleted = row['is_deleted'] as bool? ?? false
        ..lastSyncedAt = DateTime.now().toUtc()
        ..isSynced = true
        ..jsonData = jsonEncode(row);
      await financeTransactionModels.put(model);
    });
  }

  Future<void> upsertSacramentFromRemote(Map<String, dynamic> row) async {
    if (_isar == null) return;
    final id = row['id']?.toString();
    if (id == null) return;

    await db.writeTxn(() async {
      final existing =
          await sacramentModels.filter().idEqualTo(id).findFirst();
      final model = existing ?? SacramentModel();
      model
        ..id = id
        ..churchId = row['church_id']?.toString() ?? ''
        ..typeId = row['type_id']?.toString() ?? ''
        ..date = _parseDateTime(row['date']) ?? DateTime.now()
        ..memberId = row['member_id']?.toString() ?? ''
        ..memberFirstName = row['member_first_name']?.toString()
        ..memberLastName = row['member_last_name']?.toString()
        ..location = row['location']?.toString()
        ..celebrant = row['celebrant']?.toString()
        ..notes = row['notes']?.toString()
        ..updatedAt = _parseDateTime(row['updated_at'])
        ..version = (row['version'] as num?)?.toInt() ?? 1
        ..isDeleted = row['is_deleted'] as bool? ?? false
        ..lastSyncedAt = DateTime.now().toUtc()
        ..jsonData = jsonEncode(row);
      await sacramentModels.put(model);
    });
  }

  Future<void> upsertAnnonceFromRemote(Map<String, dynamic> row) async {
    if (_isar == null) return;
    final id = row['id']?.toString();
    if (id == null) return;

    await db.writeTxn(() async {
      final existing =
          await annonceModels.filter().idEqualTo(id).findFirst();
      final model = existing ?? AnnonceModel();
      model
        ..id = id
        ..churchId = row['church_id']?.toString() ?? ''
        ..type = row['type']?.toString() ?? 'general'
        ..date = _parseDateTime(row['date'] ?? row['published_at'] ?? row['created_at']) ?? DateTime.now()
        ..title = row['title']?.toString()  // nullable
        ..content = row['content']?.toString()  // nullable
        ..summary = row['summary']?.toString()
        ..status = row['status']?.toString() ?? 'BROUILLON'
        ..updatedAt = _parseDateTime(row['updated_at'])
        ..version = (row['version'] as num?)?.toInt() ?? 1
        ..isDeleted = row['is_deleted'] as bool? ?? false
        ..lastSyncedAt = DateTime.now().toUtc()
        ..jsonData = jsonEncode(row);
      await annonceModels.put(model);
    });
  }

  Future<void> upsertEventFromRemote(Map<String, dynamic> row) async {
    if (_isar == null) return;
    final id = row['id']?.toString();
    if (id == null) return;

    await db.writeTxn(() async {
      final existing = await eventModels.filter().idEqualTo(id).findFirst();
      final model = existing ?? EventModel();
      model
        ..id = id
        ..churchId = row['church_id']?.toString() ?? ''
        ..typeId = row['type_id']?.toString() ?? 'other'
        ..date = _parseDateTime(row['date'] ?? row['start_date']) ?? DateTime.now()
        ..endDate = _parseDateTime(row['end_date'])
        ..title = row['title']?.toString()  // nullable
        ..status = row['status']?.toString() ?? 'PLANIFIE'
        ..color = row['color']?.toString() ?? '#000000'
        ..updatedAt = _parseDateTime(row['updated_at'])
        ..isDeleted = row['is_deleted'] as bool? ?? false
        ..lastSyncedAt = DateTime.now().toUtc()
        ..jsonData = jsonEncode(row);
      await eventModels.put(model);
    });
  }

  Future<void> upsertGroupFromRemote(Map<String, dynamic> row) async {
    if (_isar == null) return;
    final id = row['id']?.toString();
    if (id == null) return;

    await db.writeTxn(() async {
      // GroupModel uses originalId as the unique external UUID
      final existing = await groupModels.filter().originalIdEqualTo(id).findFirst();
      final model = existing ?? GroupModel();
      model
        ..originalId = id
        ..churchId = row['church_id']?.toString() ?? ''
        ..name = row['name']?.toString() ?? ''
        ..type = _parseEnum(row['type'], GroupType.values, GroupType.cellule)
        ..updatedAt = _parseDateTime(row['updated_at'])
        ..isDeleted = row['is_deleted'] as bool? ?? false
        ..lastSyncedAt = DateTime.now().toUtc()
        ..jsonData = jsonEncode(row);
      await groupModels.put(model);
    });
  }

  Future<void> upsertGroupMembershipFromRemote(
      Map<String, dynamic> row) async {
    if (_isar == null) return;
    final id = row['id']?.toString();
    if (id == null) return;

    await db.writeTxn(() async {
      // GroupMembershipModel uses originalId as the unique external UUID
      final existing = await groupMembershipModels
          .filter()
          .originalIdEqualTo(id)
          .findFirst();
      final model = existing ?? GroupMembershipModel();
      model
        ..originalId = id
        ..churchId = row['church_id']?.toString() ?? ''
        ..groupId = row['group_id']?.toString() ?? ''
        ..memberId = row['member_id']?.toString() ?? ''
        ..role = _parseEnum(row['role'], GroupRole.values, GroupRole.member)
        ..updatedAt = _parseDateTime(row['updated_at'])
        ..lastSyncedAt = DateTime.now().toUtc()
        ..jsonData = jsonEncode(row);
      await groupMembershipModels.put(model);
    });
  }

  Future<void> upsertBudgetFromRemote(Map<String, dynamic> row) async {
    if (_isar == null) return;
    final id = row['id']?.toString();
    if (id == null) return;

    await db.writeTxn(() async {
      final existing = await budgetModels.filter().idEqualTo(id).findFirst();
      final model = existing ?? BudgetModel(
        id: id,
        churchId: row['church_id']?.toString() ?? '',
        categoryId: row['category_id']?.toString() ?? '',
        period: _parseEnum(row['period'], BudgetPeriod.values, BudgetPeriod.monthly),
        year: (row['year'] as num?)?.toInt() ?? DateTime.now().year,
        plannedAmount: (row['planned_amount'] as num?)?.toDouble() ?? 0.0,
      );
      model
        ..churchId = row['church_id']?.toString() ?? ''
        ..categoryId = row['category_id']?.toString() ?? ''
        ..period = _parseEnum(row['period'], BudgetPeriod.values, BudgetPeriod.monthly)
        ..year = (row['year'] as num?)?.toInt() ?? DateTime.now().year
        ..month = (row['month'] as num?)?.toInt()
        ..quarter = (row['quarter'] as num?)?.toInt()
        ..plannedAmount = (row['planned_amount'] as num?)?.toDouble() ?? 0.0
        ..actualAmount = (row['actual_amount'] as num?)?.toDouble() ?? 0.0
        ..isApproved = row['is_approved'] as bool? ?? false
        ..approvedBy = row['approved_by']?.toString()
        ..approvedAt = _parseDateTime(row['approved_at'])
        ..notes = row['notes']?.toString()
        ..updatedAt = _parseDateTime(row['updated_at'])
        ..isDeleted = row['is_deleted'] as bool? ?? false
        ..lastSyncedAt = DateTime.now().toUtc()
        ..jsonData = jsonEncode(row);
      await budgetModels.put(model);
    });
  }

  // ===========================================================================
  // Helpers privÃ©s
  // ===========================================================================

  DateTime? _parseDateTime(dynamic raw) {
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString())?.toUtc();
  }

  /// Parse un enum depuis sa reprÃ©sentation string.
  /// Retourne [defaultValue] si la valeur n'est pas reconnue.
  T _parseEnum<T extends Enum>(dynamic raw, List<T> values, T defaultValue) {
    if (raw == null) return defaultValue;
    final str = raw.toString();
    for (final v in values) {
      if (v.name == str) return v;
    }
    return defaultValue;
  }
}

