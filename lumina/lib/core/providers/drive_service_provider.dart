import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/global_providers.dart';
import '../services/drive_service.dart';

final driveServiceProvider = Provider<DriveService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DriveService(supabase);
});
