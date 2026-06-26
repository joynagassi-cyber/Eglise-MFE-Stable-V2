import 'package:isar/isar.dart';

part 'sync_operation_model.g.dart';

@collection
class SyncOperationModel {
  Id isarId = Isar.autoIncrement;
  
  @Index()
  late String operationId;       // UUID v4
  
  @Index()
  late String entityType;        // 'member' | 'group' | 'member_group' | 'event' | ...
  
  @Index()
  late String entityId;          // ID métier stable (UUID)
  
  late String operation;         // 'CREATE' | 'UPDATE' | 'DELETE' | 'RESTORE'
  
  late String payload;           // JSON de l'entité sérialisée
  
  @Index()
  late DateTime createdAt;
  
  late String deviceId;
  
  @Index()
  late String churchId;          // Toujours scoper par tenant
  
  late String userId;            // Auteur de l'opération
  
  int retryCount = 0;
  
  @Index()
  bool isSynced = false;
  
  @Index()
  bool hasFailed = false;
  
  String? lastError;
}
