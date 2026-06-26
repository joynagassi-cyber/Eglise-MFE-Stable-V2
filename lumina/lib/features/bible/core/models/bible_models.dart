import 'package:isar/isar.dart';

part 'bible_models.g.dart';

@collection
class BibleBookModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String identifier; // e.g., "GEN"

  late String name;

  @Index()
  late String translationId; // e.g., "ls1910"
}

@collection
class BibleChapterModel {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('chapterNumber')])
  late String bookIdentifier;

  late int chapterNumber;

  late String translationId;

  late List<String> verses;

  @Index()
  DateTime lastReadAt = DateTime.now();
}

@collection
class BibleVerseModel {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('chapter'), CompositeIndex('verse')])
  late String bookIdentifier;

  late int chapter;

  late int verse;

  @Index(type: IndexType.value, caseSensitive: false)
  late String text;

  @Index()
  late String translationId;
}

@collection
class BibleAnnotationModel {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('chapter'), CompositeIndex('verse')])
  late String bookIdentifier;

  late int chapter;

  late int verse;

  late String translationId;

  /// Type of annotation: 'highlight', 'note', 'marker'
  @Index()
  late String type;

  /// Hex color for highlight (e.g., "#ff4d00")
  String? color;

  /// Text content for notes
  String? content;

  /// Category for highlights (e.g., "Promesse", "Prière", "Avertissement")
  @Index()
  String? category;

  /// Supabase UUID for cloud sync
  String? supabaseId;

  @Index()
  late String userId;

  @Index()
  late String churchId;

  @Index()
  DateTime createdAt = DateTime.now();

  @Index()
  DateTime updatedAt = DateTime.now();
}

@embedded
class PlanDayModel {
  int? dayNumber;

  /// List of references to read, e.g. ["GEN 1-3", "MAT 1"]
  List<String>? references;

  /// Formatted title for the day's reading
  String? title;
}

@collection
class BibleReadingPlanModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String planId; // e.g., "bible_1_year", "proverbs_31"

  late String title;

  late String description;

  late int durationInDays;

  String? imageUrl; // Optional header image for the plan

  List<PlanDayModel> days = []; // All the days in this plan
}

@collection
class BiblePlanProgressModel {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('userId'), CompositeIndex('churchId')])
  late String planId; // The ID of the BibleReadingPlanModel

  late String userId;
  
  late String churchId;

  late DateTime startDate;

  /// Status: 'active', 'completed', 'cancelled'
  @Index()
  late String status;

  /// The current day the user should read
  int currentDay = 1;

  /// List of days completed (e.g., [1, 2, 3])
  List<int> completedDays = [];

  /// Chapters read per day, stored as JSON: {"1": ["GEN 1", "MAT 1"], "2": ["GEN 2"]}
  String? chaptersReadJson;

  @ignore
  bool get isCompleted => status == 'completed';

  @Index()
  DateTime lastReadAt = DateTime.now();
  
  DateTime updatedAt = DateTime.now();
}

@collection
class BibleRewardModel {
  Id id = Isar.autoIncrement;

  late String userId;
  
  @Index()
  late String churchId;

  late String planId;

  /// Type: 'badge', 'pdf', 'certificate'
  @Index()
  late String rewardType;

  String? rewardUrl;

  late DateTime grantedAt;

  DateTime createdAt = DateTime.now();
}

@collection
class BibleBookmarkModel {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('chapter'), CompositeIndex('verse')])
  late String bookIdentifier;

  late int chapter;

  late int verse;

  late String translationId;

  /// The verse text content for display
  late String verseText;

  /// Formatted reference (e.g., "Jean 3:16")
  String? reference;

  /// Custom collection/folder name (e.g., "Mes Promesses", "Louange")
  @Index()
  String collectionName = 'Général';

  /// Supabase UUID for cloud sync
  String? supabaseId;

  @Index()
  late String userId;

  @Index()
  late String churchId;

  @Index()
  DateTime createdAt = DateTime.now();
}

@collection
class BibleSearchHistoryModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String userId;

  @Index()
  late String churchId;

  @Index()
  late String query;

  int resultCount = 0;

  @Index()
  DateTime createdAt = DateTime.now();
}

@collection
class BibleReadingStatModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String userId;

  @Index()
  late String churchId;

  /// Current daily streak
  int currentStreak = 0;

  /// Maximum streak ever reached
  int maxStreak = 0;

  /// Total chapters read across all time
  int totalChaptersRead = 0;

  /// Total annotations created
  int totalAnnotations = 0;

  /// Last date a chapter was read (for streak calculation)
  DateTime? lastReadDate;

  @Index()
  DateTime updatedAt = DateTime.now();
}