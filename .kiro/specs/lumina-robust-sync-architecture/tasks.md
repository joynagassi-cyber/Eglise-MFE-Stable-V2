# Implementation Plan: Lumina Robust Sync Architecture

## Overview

This implementation plan converts the comprehensive design for a production-grade offline/online synchronization architecture into actionable coding tasks. The architecture implements an offline-first approach with reliable bidirectional sync between Isar (local database) and Supabase (remote backend), featuring conflict resolution, multi-tenant security, soft deletes, and real-time updates.

**Key Technologies**: Flutter/Dart, Isar 3.1.0+1, Supabase 2.12.2, Riverpod 2.6.1, Connectivity Plus 7.0.0

**Architecture Pattern**: Clean Architecture with layered separation (Presentation → Domain → Data)

**Core Features**: Outbox pattern, delta sync, Last Write Wins conflict resolution, exponential backoff retry, realtime subscriptions, church-based multi-tenancy

## Tasks

- [ ] 1. Set up core sync infrastructure and data models
  - [ ] 1.1 Create SyncMetadata mixin for Isar entities
    - Create `lib/core/sync/models/sync_metadata.dart`
    - Define SyncMetadata mixin with fields: updatedAt, version, isDeleted, deviceId, churchId, createdBy, lastSyncedAt, syncStatus
    - Define SyncStatus enum (synced, pending, conflict, error)
    - Add Isar annotations (@Enumerated, @Index where needed)
    - _Requirements: 1.1-1.8_
  
  - [ ] 1.2 Create SyncOperation entity for outbox queue
    - Create `lib/core/sync/models/sync_operation.dart`
    - Define SyncOperation Isar collection with @collection annotation
    - Add fields: id, entityType, entityId, operationType, payload, createdAt, attemptCount, lastAttemptAt, error, churchId, deviceId
    - Define OperationType enum (create, update, delete, restore)
    - Add indexes on createdAt, entityType, and churchId
    - _Requirements: 2.1-2.3_
  
  - [ ] 1.3 Create SyncState entity for tracking last sync timestamps
    - Create `lib/core/sync/models/sync_state.dart`
    - Define SyncState Isar collection
    - Add fields: id, entityType, lastSyncedAt, churchId
    - Add unique index on entityType
    - _Requirements: 5.1_

  - [ ] 1.4 Create Result type for error handling
    - Create `lib/core/common/result.dart`
    - Define Result<T> sealed class with Success and Failure variants
    - Add helper methods: isSuccess, isFailure, getOrNull, getOrThrow
    - _Requirements: 3.1, 22.1-22.2_
  
  - [ ]* 1.5 Write property test for SyncMetadata initialization
    - **Property 2: Schema Migration Default Initialization**
    - **Validates: Requirements 1.10, 15.4-15.8**
    - Create `test/core/sync/models/sync_metadata_test.dart`
    - Generate random entities without sync metadata
    - Apply migration logic to initialize metadata fields
    - Verify updatedAt is set, version = 1, isDeleted = false, syncStatus = pending
    - Run 100+ iterations with different entity types

- [ ] 2. Implement schema migration for existing entities
  - [ ] 2.1 Create schema migration utility
    - Create `lib/core/sync/migration/sync_metadata_migration.dart`
    - Implement migrateSyncMetadata function that processes all entity collections
    - Initialize metadata fields with defaults for existing records
    - Handle churchId extraction from existing context
    - Add migration validation logic
    - _Requirements: 15.1-15.9, 18.1-18.4_
  
  - [ ] 2.2 Implement migration rollback capability
    - Add rollback function to migration utility
    - Store pre-migration snapshot for recovery
    - Implement rollback logic to restore original state
    - _Requirements: 15.10, 18.9_
  
  - [ ]* 2.3 Write property test for migration data preservation
    - **Property 1: Schema Migration Data Preservation**
    - **Validates: Requirements 1.9, 15.3, 18.1**
    - Create `test/core/sync/migration/migration_test.dart`
    - Generate random entities with business data
    - Run migration
    - Verify all original business fields remain unchanged
    - Run 100+ iterations with different entity types and data

- [ ] 3. Checkpoint - Verify core models and migration
  - Ensure all tests pass, ask the user if questions arise.


- [ ] 4. Implement Local Data Source (Isar layer)
  - [ ] 4.1 Create LocalDataSource interface and implementation
    - Create `lib/data/local/local_data_source.dart`
    - Define LocalDataSource abstract class with methods: getPendingOperations, removeSyncOperation, insertEntity, updateEntity, softDeleteEntity, getEntityById
    - Create IsarLocalDataSource implementation
    - Inject Isar instance via constructor
    - _Requirements: 2.7, 3.9_
  
  - [ ] 4.2 Implement outbox queue operations
    - Add getPendingOperations method with churchId filter and FIFO ordering
    - Add removeSyncOperation method
    - Add updateSyncOperation method for incrementing attemptCount
    - Add batch retrieval support with limit parameter
    - _Requirements: 2.7, 2.10, 6.1-6.2_
  
  - [ ] 4.3 Implement entity CRUD operations with transaction support
    - Add insertEntity method with writeTxn wrapper
    - Add updateEntity method with writeTxn wrapper
    - Add softDeleteEntity method (sets isDeleted = true)
    - Add getEntityById method
    - Add query methods with isDeleted filtering
    - _Requirements: 3.1-3.4, 4.1-4.5_
  
  - [ ]* 4.4 Write unit tests for LocalDataSource
    - Test getPendingOperations returns operations in FIFO order
    - Test softDeleteEntity sets isDeleted flag
    - Test query methods filter out deleted entities
    - Test transaction rollback on error

- [ ] 5. Implement Repository layer with atomic transactions
  - [ ] 5.1 Create BaseRepository abstract class
    - Create `lib/domain/repositories/base_repository.dart`
    - Define abstract methods: create, update, delete, getAll, getById, getByChurchId
    - Add protected helper methods for metadata enrichment
    - _Requirements: 3.1-3.10_
  
  - [ ] 5.2 Implement MemberRepository as reference implementation
    - Create `lib/domain/repositories/member_repository.dart`
    - Implement create method with atomic transaction (entity insert + outbox enqueue)
    - Implement update method with version increment and atomic transaction
    - Implement delete method with soft delete and atomic transaction
    - Add church context validation
    - Inject LocalDataSource, currentChurchId, currentDeviceId, currentUserId
    - _Requirements: 3.1-3.10, 9.3-9.4_

  
  - [ ]* 5.3 Write property test for atomic transaction consistency
    - **Property 3: Atomic Transaction Consistency**
    - **Validates: Requirements 2.4, 3.1-3.4, 5.8**
    - Create `test/domain/repositories/repository_transaction_test.dart`
    - Generate random entity mutations (create, update, delete)
    - Execute mutation and verify both entity and SyncOperation are present
    - Simulate transaction failure and verify both are rolled back
    - Run 100+ iterations
  
  - [ ]* 5.4 Write property test for version monotonic increase
    - **Property 5: Version Monotonic Increase**
    - **Validates: Requirements 3.5**
    - Generate random entity
    - Perform multiple update operations
    - Verify version increases strictly after each update
    - Run 100+ iterations with varying update counts
  
  - [ ]* 5.5 Write property test for church context validation
    - **Property 16: Church Context Validation**
    - **Validates: Requirements 9.3-9.4**
    - Generate entities with mismatched churchId
    - Attempt repository mutation
    - Verify ChurchContextMismatchException is thrown
    - Run 100+ iterations with different churchId combinations

- [ ] 6. Implement soft delete and trash management
  - [ ] 6.1 Create TrashManager service
    - Create `lib/core/sync/services/trash_manager.dart`
    - Implement getTrashItems method with churchId filter and sorting
    - Implement restore method with atomic transaction
    - Implement permanentDelete method for admin cleanup
    - Add church context validation
    - _Requirements: 4.6-4.10, 12.1-12.10_
  
  - [ ]* 6.2 Write property test for soft delete behavior
    - **Property 8: Soft Delete Behavior**
    - **Validates: Requirements 4.1-4.3**
    - Create `test/core/sync/services/trash_manager_test.dart`
    - Generate random entities
    - Perform delete operation
    - Verify isDeleted = true, updatedAt updated, version incremented, entity still in DB
    - Run 100+ iterations
  
  - [ ]* 6.3 Write property test for soft delete filtering
    - **Property 9: Soft Delete Filtering**
    - **Validates: Requirements 4.4**
    - Generate mix of deleted and non-deleted entities
    - Query with default parameters
    - Verify no deleted entities in results
    - Run 100+ iterations

  
  - [ ]* 6.4 Write property test for soft delete round trip
    - **Property 10: Soft Delete Round Trip**
    - **Validates: Requirements 4.6-4.8, 12.4-12.7**
    - Generate random entities
    - Perform delete then restore
    - Verify isDeleted = false, business fields unchanged, updatedAt and version updated
    - Run 100+ iterations

- [ ] 7. Checkpoint - Verify repository and trash management
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 8. Implement Remote Data Source (Supabase layer)
  - [ ] 8.1 Create RemoteDataSource interface and implementation
    - Create `lib/data/remote/remote_data_source.dart`
    - Define RemoteDataSource abstract class with methods: queryChanges, pushEntity, subscribeToChanges
    - Create SupabaseRemoteDataSource implementation
    - Inject SupabaseClient via constructor
    - _Requirements: 16.1-16.10_
  
  - [ ] 8.2 Implement queryChanges for delta sync
    - Add queryChanges method with churchId and since timestamp filters
    - Build Supabase query with .eq('church_id', churchId) and .gt('updated_at', since)
    - Add ordering by updated_at
    - Handle pagination for large result sets
    - _Requirements: 5.2-5.3, 16.2-16.3_
  
  - [ ] 8.3 Implement pushEntity for all operation types
    - Add pushEntity method with switch on OperationType
    - Implement create: .insert(payload)
    - Implement update: .update(payload).eq('id', entityId)
    - Implement delete: .update({'is_deleted': true}).eq('id', entityId)
    - Implement restore: .update({'is_deleted': false}).eq('id', entityId)
    - Add error handling and classification (retriable vs non-retriable)
    - _Requirements: 6.4, 16.1, 16.5-16.6_
  
  - [ ] 8.4 Implement subscribeToChanges for realtime
    - Add subscribeToChanges method returning RealtimeChannel
    - Configure channel with church_id filter
    - Set up onPostgresChanges callback for INSERT/UPDATE/DELETE events
    - _Requirements: 8.1-8.2, 16.10_
  
  - [ ]* 8.5 Write unit tests for RemoteDataSource
    - Mock SupabaseClient
    - Test queryChanges with various filters
    - Test pushEntity for all operation types
    - Test error classification (4xx vs 5xx)
    - Test realtime subscription setup


- [ ] 9. Implement connectivity management
  - [ ] 9.1 Create ConnectivityChecker service
    - Create `lib/core/sync/services/connectivity_checker.dart`
    - Inject Connectivity and SupabaseClient
    - Implement initialize method with connectivity stream listener
    - Implement _checkConnectivity with Supabase health check
    - Add debouncing with 2-second timer
    - Expose connectivityStream and currentState
    - _Requirements: 10.1-10.9_
  
  - [ ] 9.2 Define ConnectivityState enum and stream
    - Define ConnectivityState enum (online, offline, unknown)
    - Create broadcast StreamController for connectivity events
    - Implement state update logic with change detection
    - _Requirements: 10.3-10.5_
  
  - [ ]* 9.3 Write unit tests for ConnectivityChecker
    - Mock Connectivity and SupabaseClient
    - Test state transitions (offline → online, online → offline)
    - Test debouncing behavior
    - Test Supabase health check validation

- [ ] 10. Implement error handling and retry logic
  - [ ] 10.1 Create ExponentialBackoffStrategy utility
    - Create `lib/core/sync/utils/exponential_backoff_strategy.dart`
    - Implement calculateDelay method: min(initialDelay * 2^n, maxDelay)
    - Define constants: initialDelaySeconds = 1, maxDelaySeconds = 300, maxAttempts = 10
    - Implement scheduleRetry method with Future.delayed
    - _Requirements: 11.1-11.3_
  
  - [ ] 10.2 Create ErrorClassifier utility
    - Create `lib/core/sync/utils/error_classifier.dart`
    - Implement isRetriable method with error type checking
    - Classify SocketException, TimeoutException, HttpException as retriable
    - Classify PostgrestException by code (5xx retriable, 4xx non-retriable)
    - _Requirements: 11.7-11.8_
  
  - [ ]* 10.3 Write property test for exponential backoff calculation
    - **Property 12: Exponential Backoff Calculation**
    - **Validates: Requirements 6.6, 11.1-11.3**
    - Create `test/core/sync/utils/exponential_backoff_test.dart`
    - Generate random attempt counts from 0 to maxAttempts-1
    - Calculate delay
    - Verify delay = min(1 * 2^n, 300) seconds
    - Run 100+ iterations

  
  - [ ] 10.4 Create SyncCircuitBreaker for failure protection
    - Create `lib/core/sync/utils/sync_circuit_breaker.dart`
    - Define CircuitState enum (closed, open, halfOpen)
    - Implement canAttemptSync method with state machine logic
    - Implement recordSuccess and recordFailure methods
    - Set failureThreshold = 5, resetTimeout = 5 minutes
    - _Requirements: 22.8-22.9_
  
  - [ ]* 10.5 Write unit tests for circuit breaker
    - Test state transitions (closed → open → halfOpen → closed)
    - Test failure threshold triggering
    - Test reset timeout behavior

- [ ] 11. Implement core Sync Service
  - [ ] 11.1 Create SyncService class structure
    - Create `lib/core/sync/services/sync_service.dart`
    - Inject LocalDataSource, RemoteDataSource, ConnectivityChecker
    - Add fields for currentChurchId, currentDeviceId
    - Define SyncResult class for operation results
    - _Requirements: 6.1-6.10, 7.1-7.10_
  
  - [ ] 11.2 Implement pushPendingOperations method
    - Check connectivity before proceeding
    - Retrieve pending operations from outbox (limit 50)
    - Loop through operations and call _pushOperation
    - Handle success: remove from outbox
    - Handle conflict: call _handleConflict
    - Handle retriable error: call _scheduleRetry
    - Handle non-retriable error: mark as error
    - Return SyncResult with counts
    - _Requirements: 6.1-6.10_
  
  - [ ] 11.3 Implement _pushOperation helper method
    - Delegate to RemoteDataSource.pushEntity
    - Parse RemoteOperationResult
    - Return structured result (success, conflict, retriable, error)
    - _Requirements: 6.4_
  
  - [ ] 11.4 Implement _handleConflict method with Last Write Wins
    - Retrieve local entity
    - Compare updatedAt timestamps
    - If remote newer: accept remote version, remove SyncOperation
    - If local newer: schedule retry
    - If equal: compare version numbers
    - Log conflict resolution decision
    - _Requirements: 7.1-7.10_

  
  - [ ] 11.5 Implement _scheduleRetry helper method
    - Increment attemptCount on SyncOperation
    - Calculate delay using ExponentialBackoffStrategy
    - Update lastAttemptAt timestamp
    - Check if max attempts exceeded, mark as error if so
    - _Requirements: 11.4-11.6_
  
  - [ ]* 11.6 Write property test for conflict resolution (timestamp)
    - **Property 13: Conflict Resolution Determinism (Timestamp)**
    - **Validates: Requirements 7.1-7.3**
    - Create `test/core/sync/services/sync_service_conflict_test.dart`
    - Generate pairs of conflicting entities with different updatedAt
    - Apply conflict resolution
    - Verify the version with later updatedAt is always selected
    - Run 100+ iterations
  
  - [ ]* 11.7 Write property test for conflict resolution (version)
    - **Property 14: Conflict Resolution Determinism (Version)**
    - **Validates: Requirements 7.4-7.5**
    - Generate pairs of conflicting entities with same updatedAt, different versions
    - Apply conflict resolution
    - Verify the version with higher version number is always selected
    - Run 100+ iterations

- [ ] 12. Implement delta sync pull operations
  - [ ] 12.1 Implement pullChanges method in SyncService
    - Check connectivity before proceeding
    - Retrieve lastSyncTimestamp from SyncState (or null for full sync)
    - Call RemoteDataSource.queryChanges with churchId and since filter
    - Apply changes in atomic transaction using _applyRemoteChange
    - Update lastSyncTimestamp after successful pull
    - Return SyncResult with count
    - _Requirements: 5.1-5.10_
  
  - [ ] 12.2 Implement _applyRemoteChange helper method
    - Check if entity exists locally
    - If exists: apply conflict resolution before updating
    - If not exists: insert directly
    - Update entity metadata (lastSyncedAt, syncStatus)
    - _Requirements: 5.8-5.9_
  
  - [ ] 12.3 Implement _getLastSyncTimestamp and _updateLastSyncTimestamp
    - Query SyncState collection by entityType and churchId
    - Return lastSyncedAt or null if not found
    - Update SyncState after successful sync
    - _Requirements: 5.1, 5.4-5.5_

  
  - [ ]* 12.4 Write property test for delta sync filtering
    - **Property 11: Delta Sync Filtering**
    - **Validates: Requirements 5.2**
    - Create `test/core/sync/services/sync_service_delta_test.dart`
    - Generate entities with various updatedAt timestamps
    - Set lastSyncedAt to a specific timestamp
    - Perform delta sync pull
    - Verify all returned entities have updatedAt > lastSyncedAt
    - Run 100+ iterations

- [ ] 13. Checkpoint - Verify sync service core functionality
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 14. Implement Realtime Subscription Manager
  - [ ] 14.1 Create RealtimeSubscriptionManager class
    - Create `lib/core/sync/services/realtime_subscription_manager.dart`
    - Inject RemoteDataSource, LocalDataSource, currentChurchId, currentDeviceId, SyncStatusNotifier
    - Add _activeChannels map to track subscriptions
    - _Requirements: 8.1-8.10_
  
  - [ ] 14.2 Implement subscribe method
    - Check if already subscribed to entityType
    - Call RemoteDataSource.subscribeToChanges with church filter
    - Store channel in _activeChannels map
    - Update SyncStatusNotifier with realtime status
    - _Requirements: 8.1-8.2_
  
  - [ ] 14.3 Implement _handleRealtimeEvent method
    - Validate church context from event payload
    - Check deviceId to avoid redundant updates
    - Route to _handleInsert, _handleUpdate, or _handleDelete based on event type
    - _Requirements: 8.3-8.7_
  
  - [ ] 14.4 Implement event handlers (_handleInsert, _handleUpdate, _handleDelete)
    - _handleInsert: insert entity into local storage
    - _handleUpdate: apply conflict resolution, then update if remote is newer
    - _handleDelete: apply soft delete to local entity
    - Wrap all operations in writeTxn
    - _Requirements: 8.4-8.6_
  
  - [ ] 14.5 Implement unsubscribe and unsubscribeAll methods
    - Remove channel from _activeChannels
    - Call channel.unsubscribe()
    - Update SyncStatusNotifier when all channels closed
    - _Requirements: 8.8-8.9_

  
  - [ ]* 14.6 Write property test for realtime device filtering
    - **Property 15: Realtime Event Device Filtering**
    - **Validates: Requirements 8.7, 14.6-14.7**
    - Create `test/core/sync/services/realtime_subscription_test.dart`
    - Generate realtime events with deviceId matching current device
    - Process events through _handleRealtimeEvent
    - Verify events are ignored (not applied to local storage)
    - Run 100+ iterations
  
  - [ ]* 14.7 Write unit tests for realtime event handling
    - Test INSERT event creates local entity
    - Test UPDATE event applies conflict resolution
    - Test DELETE event applies soft delete
    - Test church context validation rejects wrong churchId

- [ ] 15. Implement Sync Status observability with Riverpod
  - [ ] 15.1 Create SyncStatus state model
    - Create `lib/core/sync/models/sync_status.dart`
    - Define SyncStatus class with freezed annotation
    - Add fields: syncState, pendingOperationsCount, lastSuccessfulSync, connectivityState, realtimeStatus, failedOperations, conflicts, syncProgress
    - Define SyncState enum (idle, syncing, error)
    - Define RealtimeStatus enum (connected, disconnected, error)
    - Define FailedOperation and ConflictEvent classes
    - _Requirements: 13.1-13.9_
  
  - [ ] 15.2 Create SyncStatusNotifier Riverpod provider
    - Create `lib/core/sync/providers/sync_status_provider.dart`
    - Define SyncStatusNotifier extending Riverpod notifier
    - Implement update methods: updateSyncState, updatePendingCount, updateLastSyncTime, addFailedOperation, updateConnectivity, updateRealtimeStatus, notifyConflict
    - Implement initial state factory
    - _Requirements: 13.1-13.9_
  
  - [ ] 15.3 Create manual sync trigger method
    - Add triggerManualSync method to SyncStatusNotifier
    - Call SyncService.pushPendingOperations and pullChanges
    - Update sync state during operation
    - _Requirements: 13.10_
  
  - [ ]* 15.4 Write unit tests for SyncStatusNotifier
    - Test state updates for all update methods
    - Test initial state
    - Test manual sync trigger


- [ ] 16. Implement device tracking and identification
  - [ ] 16.1 Create DeviceIdManager service
    - Create `lib/core/sync/services/device_id_manager.dart`
    - Implement generateDeviceId method using uuid package
    - Implement persistDeviceId using flutter_secure_storage
    - Implement getDeviceId with lazy initialization
    - _Requirements: 14.1-14.3_
  
  - [ ] 16.2 Integrate deviceId into repository operations
    - Update BaseRepository to inject DeviceIdManager
    - Set deviceId field on all mutations
    - Ensure deviceId is immutable after creation
    - _Requirements: 14.4, 14.9_
  
  - [ ]* 16.3 Write unit tests for DeviceIdManager
    - Test device ID generation
    - Test persistence and retrieval
    - Test lazy initialization

- [ ] 17. Implement serialization and parsing for SyncOperations
  - [ ] 17.1 Create SyncOperationSerializer utility
    - Create `lib/core/sync/utils/sync_operation_serializer.dart`
    - Implement serialize method: entity → JSON string
    - Include all required fields and metadata
    - Exclude null values to reduce payload size
    - _Requirements: 21.3-21.6_
  
  - [ ] 17.2 Create SyncOperationParser utility
    - Create `lib/core/sync/utils/sync_operation_parser.dart`
    - Implement parse method: JSON string → entity object
    - Add error handling for invalid JSON
    - Validate payload structure against entity schema
    - _Requirements: 21.1-21.2, 21.8-21.9_
  
  - [ ]* 17.3 Write property test for serialization round trip
    - **Property 17: Sync Operation Serialization Round Trip**
    - **Validates: Requirements 21.7**
    - Create `test/core/sync/utils/serialization_test.dart`
    - Generate random entities
    - Serialize to JSON, then deserialize back
    - Verify all fields are equivalent
    - Run 100+ iterations with different entity types
  
  - [ ]* 17.4 Write property test for invalid JSON parsing
    - **Property 18: Invalid JSON Parsing Error**
    - **Validates: Requirements 21.2**
    - Generate malformed JSON strings
    - Attempt to parse
    - Verify descriptive error is returned (not crash)
    - Run 100+ iterations with various malformed inputs


- [ ] 18. Implement Supabase RLS policies and database schema
  - [ ] 18.1 Create Supabase migration for sync metadata columns
    - Create migration file in `supabase/migrations/`
    - Add columns: updated_at, version, is_deleted, device_id, church_id, created_by to all entity tables
    - Add indexes on updated_at, church_id, is_deleted, device_id
    - Set default values and constraints
    - _Requirements: 1.1-1.8, 20.4_
  
  - [ ] 18.2 Create RLS policies for multi-tenant isolation
    - Enable RLS on all entity tables
    - Create SELECT policy: church_id = auth.jwt() -> 'app_metadata' ->> 'church_id'
    - Create INSERT policy: church_id = auth.jwt() -> 'app_metadata' ->> 'church_id'
    - Create UPDATE policy: church_id = auth.jwt() -> 'app_metadata' ->> 'church_id'
    - Create DELETE policy: church_id = auth.jwt() -> 'app_metadata' ->> 'church_id'
    - _Requirements: 17.1-17.10_
  
  - [ ] 18.3 Create health_check table for connectivity validation
    - Create simple health_check table with id column
    - Insert a single row for connectivity testing
    - Grant SELECT permission to authenticated users
    - _Requirements: 10.2_
  
  - [ ]* 18.4 Write integration tests for RLS policies
    - Test SELECT with multiple church contexts
    - Test INSERT with mismatched churchId (should fail)
    - Test UPDATE with mismatched churchId (should fail)
    - Test DELETE with mismatched churchId (should fail)
    - Verify isolation between churches

- [ ] 19. Checkpoint - Verify database schema and RLS
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 20. Implement sync orchestration and scheduling
  - [ ] 20.1 Create SyncOrchestrator service
    - Create `lib/core/sync/services/sync_orchestrator.dart`
    - Inject SyncService, RealtimeSubscriptionManager, ConnectivityChecker, SyncStatusNotifier
    - Implement initialize method to set up connectivity listener
    - Implement _onConnectivityChanged to trigger sync on online transition
    - _Requirements: 10.4-10.5, 19.1-19.3_

  
  - [ ] 20.2 Implement performSync method
    - Update SyncStatusNotifier to syncing state
    - Call SyncService.pushPendingOperations
    - Call SyncService.pullChanges for each entity type
    - Update SyncStatusNotifier with results
    - Handle errors and update failed operations list
    - _Requirements: 6.9, 13.7-13.8_
  
  - [ ] 20.3 Implement background sync with WorkManager
    - Create `lib/core/sync/workers/sync_worker.dart`
    - Register periodic sync task (every 15 minutes when online)
    - Implement work execution that calls SyncOrchestrator.performSync
    - Add constraints: require network connectivity
    - _Requirements: 20.7_
  
  - [ ] 20.4 Implement sync batching and rate limiting
    - Add batch size limit (50 operations per batch)
    - Add rate limiting to avoid overwhelming Supabase
    - Implement incremental sync for large collections
    - _Requirements: 20.1-20.3, 20.5_
  
  - [ ]* 20.5 Write integration tests for sync orchestration
    - Test connectivity change triggers sync
    - Test background sync scheduling
    - Test sync batching with large operation queue
    - Test rate limiting behavior

- [ ] 21. Implement sync initialization and onboarding
  - [ ] 21.1 Create InitialSyncService
    - Create `lib/core/sync/services/initial_sync_service.dart`
    - Implement performInitialSync method with progress tracking
    - Prioritize essential data (user profile, church info)
    - Allow skip option with background sync fallback
    - _Requirements: 23.1-23.10_
  
  - [ ] 21.2 Create sync progress UI components
    - Create `lib/presentation/sync/widgets/sync_progress_indicator.dart`
    - Display sync progress percentage
    - Show current operation (e.g., "Syncing members: 50/200")
    - Add skip button for initial sync
    - _Requirements: 23.2_
  
  - [ ]* 21.3 Write unit tests for InitialSyncService
    - Test initial sync with various data sizes
    - Test skip functionality
    - Test progress tracking
    - Test error handling during initial sync


- [ ] 22. Implement error recovery and diagnostic features
  - [ ] 22.1 Create SyncErrorHandler service
    - Create `lib/core/sync/services/sync_error_handler.dart`
    - Implement handleError method with error classification
    - Return ErrorHandlingDecision (retry, markAsError, notifyUser)
    - Integrate with ExponentialBackoffStrategy and ErrorClassifier
    - _Requirements: 22.1-22.7_
  
  - [ ] 22.2 Implement manual retry functionality
    - Add retryFailedOperation method to SyncService
    - Reset attemptCount and error fields
    - Re-enqueue operation for processing
    - _Requirements: 11.10, 22.4_
  
  - [ ] 22.3 Implement clear operation functionality
    - Add clearFailedOperation method to SyncService
    - Remove operation from outbox queue
    - Update SyncStatusNotifier
    - _Requirements: 22.5_
  
  - [ ] 22.4 Create SyncLogger utility
    - Create `lib/core/sync/utils/sync_logger.dart`
    - Implement logSyncError with comprehensive metadata
    - Implement logConflictResolution for audit trail
    - Use logger package for structured logging
    - _Requirements: 7.7, 22.1_
  
  - [ ] 22.5 Implement diagnostic export functionality
    - Add exportDiagnostics method to SyncService
    - Collect sync logs, failed operations, device info, sync state
    - Export as JSON file for support troubleshooting
    - _Requirements: 22.10_
  
  - [ ]* 22.6 Write property test for error preservation in outbox
    - **Property 20: Error Preservation in Outbox**
    - **Validates: Requirements 22.2**
    - Create `test/core/sync/services/sync_error_test.dart`
    - Generate SyncOperations
    - Simulate push failure
    - Verify operation remains in outbox with attemptCount incremented and error recorded
    - Run 100+ iterations

- [ ] 23. Implement backward compatibility and feature flags
  - [ ] 23.1 Create FeatureFlagService
    - Create `lib/core/sync/services/feature_flag_service.dart`
    - Implement isSyncEnabled method with per-entity-type flags
    - Store flags in shared preferences
    - _Requirements: 18.5-18.6_

  
  - [ ] 23.2 Implement graceful handling of missing metadata
    - Update SyncService to check for missing metadata fields
    - Backfill missing fields with defaults when encountered
    - Log warnings for entities missing metadata
    - _Requirements: 18.3-18.4, 18.8_
  
  - [ ]* 23.3 Write property test for backward compatibility
    - **Property 19: Backward Compatibility Graceful Handling**
    - **Validates: Requirements 18.3-18.4**
    - Create `test/core/sync/services/backward_compatibility_test.dart`
    - Generate entities missing sync metadata fields
    - Process through sync service
    - Verify graceful handling with backfilled defaults (no crash)
    - Run 100+ iterations

- [ ] 24. Checkpoint - Verify error handling and compatibility
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 25. Implement UI components for sync status display
  - [ ] 25.1 Create SyncStatusWidget
    - Create `lib/presentation/sync/widgets/sync_status_widget.dart`
    - Display connectivity status icon
    - Display pending operations count
    - Display last sync timestamp
    - Show sync progress when syncing
    - _Requirements: 13.1-13.7_
  
  - [ ] 25.2 Create SyncErrorDialog
    - Create `lib/presentation/sync/widgets/sync_error_dialog.dart`
    - Display failed operations list
    - Show error messages
    - Provide retry and clear buttons
    - _Requirements: 13.6, 22.4-22.5_
  
  - [ ] 25.3 Create ConflictNotificationWidget
    - Create `lib/presentation/sync/widgets/conflict_notification_widget.dart`
    - Display conflict events to user
    - Show which version was selected
    - Provide details about conflicting changes
    - _Requirements: 7.8, 13.9_
  
  - [ ] 25.4 Create ManualSyncButton
    - Create `lib/presentation/sync/widgets/manual_sync_button.dart`
    - Trigger manual sync on tap
    - Show loading state during sync
    - Disable when offline
    - _Requirements: 10.10, 13.10_

  
  - [ ]* 25.5 Write widget tests for UI components
    - Test SyncStatusWidget displays correct status
    - Test SyncErrorDialog shows failed operations
    - Test ManualSyncButton triggers sync
    - Test ConflictNotificationWidget displays conflicts

- [ ] 26. Implement multi-device sync coordination
  - [ ] 26.1 Integrate deviceId filtering in realtime events
    - Verify RealtimeSubscriptionManager ignores events from current device
    - Test multi-device scenario with two simulated devices
    - _Requirements: 14.6-14.7, 19.1-19.3_
  
  - [ ] 26.2 Implement per-device sync state tracking
    - Store lastSyncedAt per device and entity type
    - Handle independent sync states for multiple devices
    - _Requirements: 19.8_
  
  - [ ]* 26.3 Write integration tests for multi-device sync
    - Simulate Device A creates entity while offline
    - Simulate Device A syncs to server
    - Simulate Device B pulls changes
    - Verify both devices have same entity state
    - Test conflict resolution when both devices modify same entity offline

- [ ] 27. Implement performance optimizations
  - [ ] 27.1 Add pagination to delta sync pull
    - Modify RemoteDataSource.queryChanges to support limit and offset
    - Implement incremental pull (100 records at a time)
    - Update SyncService.pullChanges to loop through pages
    - _Requirements: 20.2_
  
  - [ ] 27.2 Implement background isolate for sync operations
    - Create `lib/core/sync/isolates/sync_isolate.dart`
    - Move heavy sync operations to background isolate
    - Use compute function for CPU-intensive tasks
    - _Requirements: 20.7_
  
  - [ ] 27.3 Add payload compression for large operations
    - Implement compression for SyncOperation payloads > 1KB
    - Use gzip compression
    - Decompress on retrieval
    - _Requirements: 20.8_
  
  - [ ]* 27.4 Write performance tests
    - Benchmark sync with 1000+ pending operations
    - Measure query performance with 10,000+ entities
    - Test memory usage during large sync
    - Verify background isolate doesn't block UI


- [ ] 28. Implement additional property-based tests
  - [ ]* 28.1 Write property test for outbox queue persistence
    - **Property 6: Outbox Queue Persistence**
    - **Validates: Requirements 2.5**
    - Create `test/core/sync/models/outbox_persistence_test.dart`
    - Generate random SyncOperations and enqueue
    - Simulate app restart (close and reopen Isar)
    - Verify all operations still present with identical data
    - Run 100+ iterations
  
  - [ ]* 28.2 Write property test for FIFO ordering
    - **Property 7: FIFO Ordering for Same Entity**
    - **Validates: Requirements 2.6, 6.2**
    - Generate sequence of operations on same entity
    - Retrieve from outbox queue
    - Verify operations ordered by createdAt ascending
    - Run 100+ iterations with varying sequence lengths
  
  - [ ]* 28.3 Write property test for transaction rollback
    - **Property 4: Transaction Rollback Completeness**
    - **Validates: Requirements 3.4**
    - Generate entity mutations that will fail
    - Attempt mutation
    - Verify both entity and SyncOperation rolled back
    - Run 100+ iterations with different failure scenarios

- [ ] 29. Create end-to-end integration tests
  - [ ]* 29.1 Write E2E test for complete offline/online cycle
    - Simulate user creates 5 entities offline
    - Simulate user updates 3 entities offline
    - Simulate user deletes 2 entities offline
    - Simulate app goes online
    - Verify all 10 operations sync successfully
    - Verify remote state matches local state
  
  - [ ]* 29.2 Write E2E test for concurrent modifications
    - Simulate Device A and B both offline
    - Both modify same entity
    - Device A comes online first, pushes change
    - Device B comes online, pushes conflicting change
    - Verify conflict resolution selects correct version
    - Verify both devices converge to same state
  
  - [ ]* 29.3 Write E2E test for soft delete and restore
    - User deletes entity
    - Verify entity in trash
    - Sync occurs, verify remote marked deleted
    - User restores from trash
    - Verify entity not in trash
    - Sync occurs, verify remote restored

  
  - [ ]* 29.4 Write E2E test for initial onboarding sync
    - New user completes authentication
    - Initial sync downloads 500+ entities
    - Verify all entities stored locally
    - Verify sync progress displayed
    - Verify user can access app after sync

- [ ] 30. Final integration and wiring
  - [ ] 30.1 Create dependency injection setup
    - Create `lib/core/sync/di/sync_dependencies.dart`
    - Register all sync services with dependency injection container
    - Set up provider overrides for testing
    - Wire up all dependencies (SyncService, RemoteDataSource, LocalDataSource, etc.)
    - _Requirements: All_
  
  - [ ] 30.2 Integrate sync architecture into main app
    - Update main.dart to initialize SyncOrchestrator
    - Set up connectivity listener on app start
    - Initialize realtime subscriptions for all entity types
    - Register background sync worker
    - _Requirements: All_
  
  - [ ] 30.3 Update existing repositories to use sync architecture
    - Refactor existing repositories to extend BaseRepository
    - Add SyncMetadata mixin to all entity models
    - Run schema migration on app upgrade
    - _Requirements: 18.1-18.10_
  
  - [ ] 30.4 Add sync status to app UI
    - Integrate SyncStatusWidget into app bar or bottom bar
    - Show sync errors in snackbar or dialog
    - Add manual sync button to settings screen
    - _Requirements: 13.1-13.10_

- [ ] 31. Final checkpoint - Complete system verification
  - Ensure all tests pass, ask the user if questions arise.
  - Run full test suite (unit, property, integration, E2E)
  - Verify all 23 requirements are covered by implementation
  - Test on physical devices with real network conditions
  - Perform manual testing of offline/online transitions
  - Verify multi-device sync with two physical devices

## Notes

- Tasks marked with `*` are optional test tasks and can be skipped for faster MVP delivery
- Each task references specific requirements for traceability
- Property-based tests validate universal correctness properties from the design document
- Unit tests validate specific examples and edge cases
- Integration tests validate component interactions and Supabase integration
- E2E tests validate complete user workflows
- The implementation uses Dart/Flutter as specified in the design document
- All sync operations are atomic and use Isar transactions
- Conflict resolution uses Last Write Wins strategy with timestamp and version comparison
- Multi-tenant isolation is enforced at all layers (repository, sync service, RLS policies)
- The architecture supports gradual rollout with feature flags
- Background sync runs every 15 minutes when online
- Exponential backoff prevents server overload during failures
- Circuit breaker protects against extended outages


## Task Dependency Graph

```json
{
  "waves": [
    {
      "id": 0,
      "tasks": ["1.1", "1.2", "1.3", "1.4"]
    },
    {
      "id": 1,
      "tasks": ["1.5", "2.1", "2.2"]
    },
    {
      "id": 2,
      "tasks": ["2.3", "4.1", "4.2"]
    },
    {
      "id": 3,
      "tasks": ["4.3", "4.4", "5.1"]
    },
    {
      "id": 4,
      "tasks": ["5.2", "6.1"]
    },
    {
      "id": 5,
      "tasks": ["5.3", "5.4", "5.5", "6.2", "6.3", "6.4"]
    },
    {
      "id": 6,
      "tasks": ["8.1", "8.2", "8.3", "8.4"]
    },
    {
      "id": 7,
      "tasks": ["8.5", "9.1", "9.2"]
    },
    {
      "id": 8,
      "tasks": ["9.3", "10.1", "10.2"]
    },
    {
      "id": 9,
      "tasks": ["10.3", "10.4", "10.5"]
    },
    {
      "id": 10,
      "tasks": ["11.1", "11.2", "11.3"]
    },
    {
      "id": 11,
      "tasks": ["11.4", "11.5"]
    },
    {
      "id": 12,
      "tasks": ["11.6", "11.7", "12.1", "12.2", "12.3"]
    },
    {
      "id": 13,
      "tasks": ["12.4", "14.1", "14.2"]
    },
    {
      "id": 14,
      "tasks": ["14.3", "14.4", "14.5"]
    },
    {
      "id": 15,
      "tasks": ["14.6", "14.7", "15.1", "15.2"]
    },
    {
      "id": 16,
      "tasks": ["15.3", "15.4", "16.1"]
    },
    {
      "id": 17,
      "tasks": ["16.2", "16.3", "17.1", "17.2"]
    },
    {
      "id": 18,
      "tasks": ["17.3", "17.4", "18.1"]
    },
    {
      "id": 19,
      "tasks": ["18.2", "18.3"]
    },
    {
      "id": 20,
      "tasks": ["18.4", "20.1", "20.2"]
    },
    {
      "id": 21,
      "tasks": ["20.3", "20.4", "20.5"]
    },
    {
      "id": 22,
      "tasks": ["21.1", "21.2"]
    },
    {
      "id": 23,
      "tasks": ["21.3", "22.1", "22.2", "22.3"]
    },
    {
      "id": 24,
      "tasks": ["22.4", "22.5", "22.6"]
    },
    {
      "id": 25,
      "tasks": ["23.1", "23.2"]
    },
    {
      "id": 26,
      "tasks": ["23.3", "25.1", "25.2", "25.3", "25.4"]
    },
    {
      "id": 27,
      "tasks": ["25.5", "26.1", "26.2"]
    },
    {
      "id": 28,
      "tasks": ["26.3", "27.1", "27.2", "27.3"]
    },
    {
      "id": 29,
      "tasks": ["27.4", "28.1", "28.2", "28.3"]
    },
    {
      "id": 30,
      "tasks": ["29.1", "29.2", "29.3", "29.4"]
    },
    {
      "id": 31,
      "tasks": ["30.1", "30.2"]
    },
    {
      "id": 32,
      "tasks": ["30.3", "30.4"]
    }
  ]
}
```
