import 'package:isar/isar.dart';

part 'sync_item_model.g.dart';

@collection
class SyncItemModel {
  Id isarId = Isar.autoIncrement;

  @Index()
  late String tableName;

  late String action; // 'INSERT', 'UPDATE', 'DELETE'

  late String jsonData;

  @Index()
  late DateTime createdAt;

  int attempts = 0;

  @Index()
  bool isProcessing = false;

  @Index()
  bool isConflict = false;

  @Index()
  String? churchId;

  DateTime? lastUpdated;

  String? lastError;

  String? remoteData; // JSON string of the record on the server

  // Optionnel: ID local pour réconciliation si nécessaire
  String? localId;

  // Ajouts pour la phase 1
  late String operationId;
  late String deviceId;
  late String userId;
  bool isSynced = false;
  bool hasFailed = false;
}
