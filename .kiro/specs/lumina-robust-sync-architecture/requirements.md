# Requirements Document

## Introduction

This document specifies the requirements for implementing a production-grade offline/online synchronization architecture for Lumina, a large-scale Flutter church management application. The system must provide robust offline-first capabilities with reliable synchronization, conflict resolution, multi-tenant security, and real-time updates while maintaining data integrity across multiple devices and ensuring backward compatibility with existing data.

## Glossary

- **Sync_Service**: The core synchronization orchestrator responsible for coordinating push, pull, and real-time synchronization operations
- **Outbox_Queue**: A persistent queue of pending local mutations awaiting synchronization to the remote backend
- **Sync_Operation**: A record in the Outbox_Queue representing a single create, update, or delete operation
- **Remote_Data_Source**: The data layer component responsible for all Supabase API interactions
- **Local_Data_Source**: The data layer component responsible for all Isar database operations
- **Repository**: The domain layer component that coordinates between Local_Data_Source and Remote_Data_Source
- **Sync_Metadata**: Timestamp, version, and tracking fields attached to entities for synchronization coordination
- **Delta_Sync**: Synchronization strategy that transfers only changes since the last successful sync
- **Soft_Delete**: Marking records as deleted without physical removal, enabling restore and sync propagation
- **Church_Context**: The multi-tenant isolation boundary enforced by church_id in RLS policies
- **Device_Context**: The device-specific tracking boundary identified by deviceId
- **Conflict_Resolution_Strategy**: The algorithm used to resolve concurrent modifications (Last Write Wins by updatedAt + version)
- **RLS_Policy**: Row Level Security policy in PostgreSQL that enforces church_id isolation
- **Realtime_Subscription**: Supabase Realtime channel subscription for live data updates
- **Connectivity_Checker**: Component that performs real connectivity validation beyond network status
- **Trash_Manager**: Component responsible for managing soft-deleted records and restore operations
- **Sync_Status_Provider**: Riverpod provider exposing synchronization state for UI observability
- **Atomic_Transaction**: A writeTxn operation in Isar that ensures all-or-nothing execution
- **Schema_Migration**: Isar schema version upgrade that transforms existing data to new structure
- **Exponential_Backoff**: Retry strategy with progressively increasing delays between attempts
- **TYPE_A_Data**: Church-wide shared data (events, announcements, ministries)
- **TYPE_B_Data**: Member-specific private data (attendance, contributions, personal info)

## Requirements

### Requirement 1: Sync Metadata Enrichment

**User Story:** As a system architect, I want all Isar models enriched with synchronization metadata, so that the system can track changes, resolve conflicts, and coordinate multi-device synchronization.

#### Acceptance Criteria

1. THE Local_Data_Source SHALL add updatedAt timestamp field to all Isar entity models
2. THE Local_Data_Source SHALL add version integer field to all Isar entity models
3. THE Local_Data_Source SHALL add isDeleted boolean field to all Isar entity models
4. THE Local_Data_Source SHALL add deviceId string field to all Isar entity models
5. THE Local_Data_Source SHALL add churchId string field to all Isar entity models
6. THE Local_Data_Source SHALL add createdBy string field to all Isar entity models
7. THE Local_Data_Source SHALL add lastSyncedAt nullable timestamp field to all Isar entity models
8. THE Local_Data_Source SHALL add syncStatus enum field to all Isar entity models with values (synced, pending, conflict, error)
9. THE Schema_Migration SHALL preserve all existing data when adding new metadata fields
10. THE Schema_Migration SHALL initialize new metadata fields with sensible defaults for existing records

### Requirement 2: Outbox Pattern Implementation

**User Story:** As a developer, I want an outbox queue for pending operations, so that local mutations are reliably synchronized even after app restarts or connectivity failures.

#### Acceptance Criteria

1. THE Local_Data_Source SHALL create a SyncOperation Isar collection with fields (id, entityType, entityId, operationType, payload, createdAt, attemptCount, lastAttemptAt, error)
2. THE Local_Data_Source SHALL create an index on SyncOperation.createdAt for ordered processing
3. THE Local_Data_Source SHALL create an index on SyncOperation.entityType for filtering
4. WHEN a local mutation occurs, THE Repository SHALL enqueue a SyncOperation within the same Atomic_Transaction
5. THE Outbox_Queue SHALL persist operations across app restarts
6. THE Outbox_Queue SHALL maintain FIFO ordering for operations on the same entity
7. THE Outbox_Queue SHALL support batch retrieval of pending operations
8. WHEN a SyncOperation succeeds, THE Sync_Service SHALL remove it from the Outbox_Queue
9. WHEN a SyncOperation fails, THE Sync_Service SHALL increment attemptCount and record the error
10. THE Outbox_Queue SHALL support filtering operations by entityType and churchId

### Requirement 3: Atomic Repository Operations

**User Story:** As a developer, I want all repository mutations to use atomic transactions with outbox enqueuing, so that local state and sync queue remain consistent.

#### Acceptance Criteria

1. WHEN creating an entity, THE Repository SHALL execute both the entity insert and SyncOperation enqueue within a single Atomic_Transaction
2. WHEN updating an entity, THE Repository SHALL execute both the entity update and SyncOperation enqueue within a single Atomic_Transaction
3. WHEN deleting an entity, THE Repository SHALL execute both the soft delete and SyncOperation enqueue within a single Atomic_Transaction
4. IF an Atomic_Transaction fails, THEN THE Repository SHALL rollback both the entity change and the SyncOperation enqueue
5. THE Repository SHALL increment the version field on every update operation
6. THE Repository SHALL update the updatedAt timestamp on every mutation
7. THE Repository SHALL set the deviceId to the current device identifier on every mutation
8. THE Repository SHALL validate churchId matches the current Church_Context before mutations
9. THE Repository SHALL NOT contain any direct Supabase API calls
10. THE Repository SHALL delegate all remote operations to the Remote_Data_Source

### Requirement 4: Soft Delete Implementation

**User Story:** As a user, I want deleted items to be recoverable and synchronized across devices, so that accidental deletions can be undone and all devices reflect the deletion state.

#### Acceptance Criteria

1. WHEN a delete operation is requested, THE Repository SHALL set isDeleted to true instead of physically removing the record
2. WHEN a delete operation is requested, THE Repository SHALL update the updatedAt timestamp
3. WHEN a delete operation is requested, THE Repository SHALL increment the version field
4. THE Repository SHALL filter out records where isDeleted is true from all query results by default
5. WHERE a trash view is requested, THE Repository SHALL return records where isDeleted is true
6. THE Trash_Manager SHALL provide a restore operation that sets isDeleted to false
7. WHEN restoring a record, THE Trash_Manager SHALL update updatedAt and increment version
8. WHEN restoring a record, THE Trash_Manager SHALL enqueue a SyncOperation for the restore
9. THE Soft_Delete SHALL propagate to remote backend through synchronization
10. THE Remote_Data_Source SHALL apply soft deletes to Supabase records

### Requirement 5: Delta Sync Pull Implementation

**User Story:** As a user, I want the system to only download changes since the last sync, so that synchronization is fast and bandwidth-efficient.

#### Acceptance Criteria

1. THE Sync_Service SHALL track the last successful sync timestamp per entity type
2. WHEN pulling updates, THE Sync_Service SHALL request only records where updatedAt is greater than the last sync timestamp
3. THE Remote_Data_Source SHALL query Supabase with updatedAt filter for delta sync
4. THE Sync_Service SHALL update the last sync timestamp only after successful pull completion
5. WHEN a pull operation fails, THE Sync_Service SHALL retain the previous last sync timestamp
6. THE Sync_Service SHALL support full sync mode that ignores the last sync timestamp
7. WHERE a full sync is requested, THE Sync_Service SHALL download all records regardless of updatedAt
8. THE Sync_Service SHALL apply pulled updates to local storage within an Atomic_Transaction
9. THE Sync_Service SHALL resolve conflicts when applying pulled updates
10. THE Delta_Sync SHALL filter by churchId to respect multi-tenant boundaries

### Requirement 6: Outbox Push Implementation

**User Story:** As a user, I want pending local changes automatically pushed to the server when online, so that my changes are backed up and visible to other devices.

#### Acceptance Criteria

1. WHEN connectivity is available, THE Sync_Service SHALL retrieve pending operations from the Outbox_Queue
2. THE Sync_Service SHALL process SyncOperations in FIFO order based on createdAt
3. THE Sync_Service SHALL batch operations by entityType for efficient processing
4. WHEN pushing a SyncOperation, THE Sync_Service SHALL delegate to Remote_Data_Source
5. WHEN a push succeeds, THE Sync_Service SHALL remove the SyncOperation from the Outbox_Queue
6. WHEN a push fails with a retriable error, THE Sync_Service SHALL apply Exponential_Backoff
7. WHEN a push fails with a non-retriable error, THE Sync_Service SHALL mark the operation as error and stop retrying
8. THE Sync_Service SHALL limit retry attempts to a maximum count (e.g., 10 attempts)
9. THE Sync_Service SHALL expose push progress through Sync_Status_Provider
10. THE Sync_Service SHALL handle conflict responses from the server by applying Conflict_Resolution_Strategy

### Requirement 7: Conflict Resolution

**User Story:** As a system architect, I want conflicts resolved using Last Write Wins with version checking, so that concurrent modifications are handled predictably and data integrity is maintained.

#### Acceptance Criteria

1. WHEN a conflict is detected, THE Sync_Service SHALL compare updatedAt timestamps
2. IF the remote updatedAt is newer, THEN THE Sync_Service SHALL accept the remote version and discard the local change
3. IF the local updatedAt is newer, THEN THE Sync_Service SHALL retry pushing the local change
4. IF updatedAt timestamps are equal, THEN THE Sync_Service SHALL compare version numbers
5. THE Sync_Service SHALL accept the version with the higher version number
6. WHEN accepting a remote version, THE Sync_Service SHALL update local storage and remove the conflicting SyncOperation
7. WHEN a conflict is resolved, THE Sync_Service SHALL log the conflict details for audit
8. THE Sync_Service SHALL expose conflict events through Sync_Status_Provider for UI notification
9. THE Conflict_Resolution_Strategy SHALL preserve the churchId and createdBy of the winning version
10. THE Conflict_Resolution_Strategy SHALL update deviceId to reflect the device of the winning version

### Requirement 8: Realtime Subscription Management

**User Story:** As a user, I want live updates from the server pushed to my device, so that I see changes made by other users without manual refresh.

#### Acceptance Criteria

1. WHEN the app is online, THE Sync_Service SHALL establish Realtime_Subscriptions for relevant entity types
2. THE Sync_Service SHALL filter Realtime_Subscriptions by churchId to respect Church_Context
3. WHEN a realtime event is received, THE Sync_Service SHALL validate the event belongs to the current Church_Context
4. WHEN a realtime INSERT event is received, THE Sync_Service SHALL insert the entity into local storage if not present
5. WHEN a realtime UPDATE event is received, THE Sync_Service SHALL apply Conflict_Resolution_Strategy before updating local storage
6. WHEN a realtime DELETE event is received, THE Sync_Service SHALL apply the soft delete to local storage
7. THE Sync_Service SHALL ignore realtime events for changes originating from the current Device_Context
8. WHEN connectivity is lost, THE Sync_Service SHALL gracefully close Realtime_Subscriptions
9. WHEN connectivity is restored, THE Sync_Service SHALL re-establish Realtime_Subscriptions
10. THE Sync_Service SHALL expose realtime connection status through Sync_Status_Provider

### Requirement 9: Multi-Tenant Security Enforcement

**User Story:** As a security architect, I want church_id isolation enforced at all layers, so that users can only access data belonging to their church.

#### Acceptance Criteria

1. THE Remote_Data_Source SHALL include churchId in all Supabase queries
2. THE RLS_Policy SHALL enforce that users can only access rows where churchId matches their authenticated church
3. THE Repository SHALL validate that all mutations include a valid churchId matching the current Church_Context
4. THE Repository SHALL reject operations with mismatched churchId
5. THE Sync_Service SHALL filter Outbox_Queue operations by churchId before pushing
6. THE Sync_Service SHALL filter pulled updates by churchId before applying to local storage
7. THE Realtime_Subscription SHALL filter events by churchId
8. THE Local_Data_Source SHALL create an index on churchId for all entity collections
9. THE Repository SHALL NOT allow churchId to be modified after entity creation
10. THE Sync_Service SHALL validate churchId consistency across related entities (e.g., member and member_groups)

### Requirement 10: Connectivity Management

**User Story:** As a user, I want the system to accurately detect connectivity and adapt synchronization behavior, so that sync operations only occur when truly online.

#### Acceptance Criteria

1. THE Connectivity_Checker SHALL perform real connectivity validation beyond network interface status
2. THE Connectivity_Checker SHALL attempt a lightweight request to Supabase to verify actual connectivity
3. THE Connectivity_Checker SHALL expose connectivity state through a Riverpod provider
4. WHEN connectivity changes from offline to online, THE Sync_Service SHALL trigger a sync cycle
5. WHEN connectivity changes from online to offline, THE Sync_Service SHALL pause sync operations
6. THE Sync_Service SHALL NOT attempt push operations when Connectivity_Checker reports offline
7. THE Sync_Service SHALL queue operations locally when offline
8. THE Connectivity_Checker SHALL implement debouncing to avoid rapid state changes
9. THE Connectivity_Checker SHALL expose connectivity history for debugging
10. THE Sync_Service SHALL respect manual sync triggers regardless of automatic connectivity-based sync

### Requirement 11: Retry with Exponential Backoff

**User Story:** As a system architect, I want failed sync operations retried with exponential backoff, so that transient failures are handled gracefully without overwhelming the server.

#### Acceptance Criteria

1. WHEN a push operation fails with a retriable error, THE Sync_Service SHALL schedule a retry with Exponential_Backoff
2. THE Exponential_Backoff SHALL use an initial delay of 1 second
3. THE Exponential_Backoff SHALL double the delay after each failed attempt up to a maximum of 5 minutes
4. THE Sync_Service SHALL track attemptCount for each SyncOperation
5. THE Sync_Service SHALL stop retrying after 10 failed attempts
6. WHEN maximum attempts are reached, THE Sync_Service SHALL mark the SyncOperation as error
7. THE Sync_Service SHALL classify errors as retriable (network, timeout, 5xx) or non-retriable (4xx validation errors)
8. WHEN a non-retriable error occurs, THE Sync_Service SHALL immediately mark the operation as error without retrying
9. THE Sync_Service SHALL expose retry status through Sync_Status_Provider
10. THE Sync_Service SHALL allow manual retry of failed operations from the UI

### Requirement 12: Trash and Restore Functionality

**User Story:** As a user, I want to view deleted items in a trash view and restore them if needed, so that I can recover from accidental deletions.

#### Acceptance Criteria

1. THE Trash_Manager SHALL provide a method to retrieve all soft-deleted entities for the current Church_Context
2. THE Trash_Manager SHALL filter trash items by entityType
3. THE Trash_Manager SHALL sort trash items by updatedAt descending (most recently deleted first)
4. WHEN a restore operation is requested, THE Trash_Manager SHALL set isDeleted to false
5. WHEN a restore operation is requested, THE Trash_Manager SHALL update updatedAt to current timestamp
6. WHEN a restore operation is requested, THE Trash_Manager SHALL increment the version field
7. WHEN a restore operation is requested, THE Trash_Manager SHALL enqueue a SyncOperation for the restore
8. THE Trash_Manager SHALL validate that the entity belongs to the current Church_Context before restore
9. THE Trash_Manager SHALL provide a permanent delete method for administrative cleanup
10. WHERE permanent delete is used, THE Trash_Manager SHALL physically remove the record and enqueue a delete SyncOperation

### Requirement 13: Sync Status Observability

**User Story:** As a user, I want to see synchronization status in the UI, so that I know when my changes are saved and when sync issues occur.

#### Acceptance Criteria

1. THE Sync_Status_Provider SHALL expose the current sync state (idle, syncing, error)
2. THE Sync_Status_Provider SHALL expose the count of pending operations in the Outbox_Queue
3. THE Sync_Status_Provider SHALL expose the timestamp of the last successful sync
4. THE Sync_Status_Provider SHALL expose connectivity status from Connectivity_Checker
5. THE Sync_Status_Provider SHALL expose realtime connection status
6. THE Sync_Status_Provider SHALL expose a list of failed operations with error details
7. THE Sync_Status_Provider SHALL expose sync progress (e.g., "Syncing 5 of 20 items")
8. THE Sync_Status_Provider SHALL emit events for sync start, success, and failure
9. THE Sync_Status_Provider SHALL expose conflict events for UI notification
10. THE Sync_Status_Provider SHALL provide a method to trigger manual sync

### Requirement 14: Device Tracking

**User Story:** As a system architect, I want all mutations tagged with deviceId, so that the system can track which device made each change and avoid syncing changes back to the originating device.

#### Acceptance Criteria

1. THE Sync_Service SHALL generate a unique deviceId on first app launch
2. THE Sync_Service SHALL persist the deviceId in secure local storage
3. WHEN a mutation occurs, THE Repository SHALL set the deviceId field to the current device identifier
4. THE Remote_Data_Source SHALL include deviceId when pushing changes to Supabase
5. THE Sync_Service SHALL store deviceId in Supabase records for audit trail
6. WHEN receiving realtime events, THE Sync_Service SHALL compare the event deviceId with the current deviceId
7. IF the event deviceId matches the current deviceId, THEN THE Sync_Service SHALL ignore the event to avoid redundant updates
8. THE Sync_Service SHALL expose device information through Sync_Status_Provider for debugging
9. THE Repository SHALL NOT allow deviceId to be manually modified by application code
10. THE Sync_Service SHALL include deviceId in conflict resolution logging

### Requirement 15: Schema Migration Strategy

**User Story:** As a developer, I want a clear Isar schema migration strategy, so that existing user data is preserved when deploying sync metadata enrichment.

#### Acceptance Criteria

1. THE Schema_Migration SHALL increment the Isar schema version number
2. THE Schema_Migration SHALL provide migration logic to add new metadata fields to existing collections
3. THE Schema_Migration SHALL initialize updatedAt with the current timestamp for existing records
4. THE Schema_Migration SHALL initialize version to 1 for existing records
5. THE Schema_Migration SHALL initialize isDeleted to false for existing records
6. THE Schema_Migration SHALL initialize deviceId to a migration sentinel value for existing records
7. THE Schema_Migration SHALL initialize churchId from existing context or user profile for existing records
8. THE Schema_Migration SHALL initialize syncStatus to pending for existing records to trigger initial sync
9. THE Schema_Migration SHALL validate data integrity after migration
10. THE Schema_Migration SHALL provide rollback capability in case of migration failure

### Requirement 16: Remote Data Source Refactoring

**User Story:** As a developer, I want all Supabase interactions isolated in RemoteDataSource, so that the architecture maintains clean separation of concerns.

#### Acceptance Criteria

1. THE Remote_Data_Source SHALL provide methods for create, update, delete, and query operations for each entity type
2. THE Remote_Data_Source SHALL include churchId filter in all query operations
3. THE Remote_Data_Source SHALL include updatedAt filter for delta sync queries
4. THE Remote_Data_Source SHALL handle Supabase authentication token management
5. THE Remote_Data_Source SHALL handle Supabase error responses and map them to domain exceptions
6. THE Remote_Data_Source SHALL implement retry logic for transient Supabase failures
7. THE Remote_Data_Source SHALL log all Supabase API calls for debugging
8. THE Remote_Data_Source SHALL validate response data structure before returning to Repository
9. THE Remote_Data_Source SHALL NOT contain any business logic
10. THE Remote_Data_Source SHALL expose methods for establishing and managing Realtime_Subscriptions

### Requirement 17: RLS Policy Enforcement

**User Story:** As a security architect, I want RLS policies enforced on all Supabase tables, so that church_id isolation is guaranteed at the database level.

#### Acceptance Criteria

1. THE RLS_Policy SHALL enforce that SELECT operations only return rows where churchId matches the authenticated user's church
2. THE RLS_Policy SHALL enforce that INSERT operations only succeed if churchId matches the authenticated user's church
3. THE RLS_Policy SHALL enforce that UPDATE operations only succeed if churchId matches the authenticated user's church
4. THE RLS_Policy SHALL enforce that DELETE operations only succeed if churchId matches the authenticated user's church
5. THE RLS_Policy SHALL be enabled on all entity tables
6. THE RLS_Policy SHALL use Supabase auth.jwt() to extract the user's churchId claim
7. THE RLS_Policy SHALL deny access if the churchId claim is missing
8. THE RLS_Policy SHALL apply to both TYPE_A_Data and TYPE_B_Data tables
9. THE RLS_Policy SHALL be tested with multiple church contexts to verify isolation
10. THE RLS_Policy SHALL be documented in migration files with clear comments

### Requirement 18: Backward Compatibility

**User Story:** As a product manager, I want the sync architecture to maintain backward compatibility with existing data, so that users experience no data loss or disruption during rollout.

#### Acceptance Criteria

1. THE Schema_Migration SHALL preserve all existing entity fields and data
2. THE Repository SHALL continue to support existing query methods without breaking changes
3. THE Sync_Service SHALL handle entities with missing metadata fields gracefully during transition period
4. THE Sync_Service SHALL backfill missing metadata fields when entities are first synced
5. THE Repository SHALL provide feature flags to enable/disable sync functionality per entity type
6. THE Sync_Service SHALL support gradual rollout by entity type
7. THE Repository SHALL maintain existing API contracts for presentation layer
8. THE Sync_Service SHALL log warnings for entities missing required metadata fields
9. THE Schema_Migration SHALL be reversible to support rollback if needed
10. THE Sync_Service SHALL provide a migration mode that performs initial sync without disrupting user workflow

### Requirement 19: Multi-Device Sync Coordination

**User Story:** As a user with multiple devices, I want my data synchronized across all devices, so that I can seamlessly switch between devices without data loss.

#### Acceptance Criteria

1. WHEN a mutation occurs on Device A, THE Sync_Service SHALL push the change to Supabase
2. WHEN Device B is online, THE Sync_Service SHALL pull the change from Supabase
3. THE Sync_Service SHALL apply pulled changes to Device B's local storage
4. THE Sync_Service SHALL resolve conflicts if Device B has pending conflicting changes
5. THE Sync_Service SHALL use Realtime_Subscriptions to push changes to Device B immediately when online
6. THE Sync_Service SHALL handle the case where multiple devices are offline and later come online
7. THE Sync_Service SHALL ensure eventual consistency across all devices for the same Church_Context
8. THE Sync_Service SHALL track per-device sync state independently
9. THE Sync_Service SHALL handle device-specific data (e.g., UI preferences) separately from shared church data
10. THE Sync_Service SHALL provide conflict resolution UI when automatic resolution is not possible

### Requirement 20: Performance and Scalability

**User Story:** As a system architect, I want the sync architecture to perform efficiently at scale, so that the system remains responsive with large datasets and many concurrent users.

#### Acceptance Criteria

1. THE Sync_Service SHALL batch operations to minimize network round trips
2. THE Sync_Service SHALL use pagination when pulling large datasets
3. THE Sync_Service SHALL limit the number of concurrent sync operations
4. THE Local_Data_Source SHALL use indexes on churchId, updatedAt, and isDeleted for query performance
5. THE Sync_Service SHALL implement rate limiting to avoid overwhelming Supabase
6. THE Sync_Service SHALL prioritize user-initiated operations over background sync
7. THE Sync_Service SHALL use background isolates for sync operations to avoid blocking the UI thread
8. THE Sync_Service SHALL compress large payloads before transmission
9. THE Sync_Service SHALL implement incremental sync for large collections (e.g., sync 100 records at a time)
10. THE Sync_Service SHALL monitor and log sync performance metrics (duration, record count, error rate)

### Requirement 21: Parser and Serializer for Sync Operations

**User Story:** As a developer, I want robust parsing and serialization of SyncOperation payloads, so that entity data is correctly encoded and decoded during synchronization.

#### Acceptance Criteria

1. THE Sync_Operation_Parser SHALL parse JSON payload strings into entity objects
2. WHEN an invalid JSON payload is encountered, THE Sync_Operation_Parser SHALL return a descriptive error
3. THE Sync_Operation_Serializer SHALL serialize entity objects into JSON payload strings
4. THE Sync_Operation_Serializer SHALL include all required entity fields in the serialized payload
5. THE Sync_Operation_Serializer SHALL exclude null values from the serialized payload to reduce size
6. THE Sync_Operation_Pretty_Printer SHALL format SyncOperation payloads for debugging and logging
7. FOR ALL valid entity objects, THE round-trip property SHALL hold: parsing then serializing then parsing SHALL produce an equivalent object
8. THE Sync_Operation_Parser SHALL validate payload structure against entity schema
9. THE Sync_Operation_Parser SHALL handle schema version differences gracefully
10. THE Sync_Operation_Serializer SHALL include metadata fields (updatedAt, version, deviceId, churchId) in the payload

### Requirement 22: Error Handling and Recovery

**User Story:** As a user, I want the system to handle errors gracefully and provide recovery options, so that sync failures don't result in data loss or app crashes.

#### Acceptance Criteria

1. WHEN a sync error occurs, THE Sync_Service SHALL log detailed error information including stack trace
2. WHEN a sync error occurs, THE Sync_Service SHALL preserve the failed operation in the Outbox_Queue
3. THE Sync_Service SHALL expose error details through Sync_Status_Provider for UI display
4. THE Sync_Service SHALL provide a manual retry option for failed operations
5. THE Sync_Service SHALL provide a clear operation option to remove failed operations from the queue
6. WHEN a critical error occurs, THE Sync_Service SHALL notify the user through the UI
7. THE Sync_Service SHALL categorize errors by severity (warning, error, critical)
8. THE Sync_Service SHALL implement circuit breaker pattern to stop sync attempts after repeated failures
9. WHEN the circuit breaker is open, THE Sync_Service SHALL periodically test connectivity before resuming
10. THE Sync_Service SHALL provide diagnostic information for support troubleshooting

### Requirement 23: Sync Initialization and Onboarding

**User Story:** As a new user, I want the app to perform initial sync during onboarding, so that I have access to church data immediately after login.

#### Acceptance Criteria

1. WHEN a user completes authentication during onboarding, THE Sync_Service SHALL trigger an initial full sync
2. THE Sync_Service SHALL display sync progress during the onboarding flow
3. THE Sync_Service SHALL prioritize essential data (user profile, church info) before secondary data
4. THE Sync_Service SHALL allow the user to skip initial sync and continue in offline mode
5. IF initial sync is skipped, THEN THE Sync_Service SHALL perform background sync after onboarding completes
6. THE Sync_Service SHALL handle initial sync failures gracefully and offer retry
7. THE Sync_Service SHALL validate that essential data is present before allowing app access
8. THE Sync_Service SHALL store the initial sync completion flag to avoid repeating on subsequent launches
9. THE Sync_Service SHALL support incremental onboarding sync (sync data as user navigates)
10. THE Sync_Service SHALL respect the 4-step onboarding flow and integrate sync at the appropriate step

### Requirement 24: Audit Trail and Logging

**User Story:** As an administrator, I want detailed audit logs of sync operations, so that I can troubleshoot issues and track data changes.

#### Acceptance Criteria

1. THE Sync_Service SHALL log all sync operations with timestamp, entityType, operationType, and result
2. THE Sync_Service SHALL log conflict resolutions with details of both versions
3. THE Sync_Service SHALL log all errors with full context (entity, operation, error message, stack trace)
4. THE Sync_Service SHALL log connectivity state changes
5. THE Sync_Service SHALL log realtime subscription events (connected, disconnected, error)
6. THE Sync_Service SHALL provide log filtering by severity, entityType, and date range
7. THE Sync_Service SHALL persist logs locally for offline review
8. THE Sync_Service SHALL provide log export functionality for support tickets
9. THE Sync_Service SHALL implement log rotation to prevent excessive storage usage
10. THE Sync_Service SHALL include deviceId and churchId in all log entries for multi-tenant debugging

### Requirement 25: Testing and Validation

**User Story:** As a QA engineer, I want comprehensive tests for the sync architecture, so that I can verify correctness and catch regressions.

#### Acceptance Criteria

1. THE Sync_Service SHALL have unit tests for conflict resolution logic
2. THE Sync_Service SHALL have unit tests for exponential backoff calculation
3. THE Repository SHALL have unit tests for atomic transaction behavior
4. THE Sync_Operation_Parser SHALL have property-based tests for round-trip serialization
5. THE Sync_Service SHALL have integration tests for push/pull/realtime flows
6. THE Sync_Service SHALL have integration tests for multi-device sync scenarios
7. THE RLS_Policy SHALL have integration tests verifying church_id isolation
8. THE Schema_Migration SHALL have tests validating data preservation
9. THE Connectivity_Checker SHALL have tests for connectivity state transitions
10. THE Sync_Service SHALL have end-to-end tests simulating offline/online transitions with pending operations
