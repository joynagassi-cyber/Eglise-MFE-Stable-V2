import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:lumina/features/membres/data/repositories/supabase_member_repository.dart';
import 'package:lumina/features/membres/domain/repositories/member_repository.dart';
import 'package:lumina/features/profile/data/repositories/supabase_profile_repository.dart';
import 'package:lumina/features/profile/domain/repositories/profile_repository.dart';

part 'repository_providers_profile.g.dart';

@Riverpod(keepAlive: true)
MemberRepository memberRepository(MemberRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  return SupabaseMemberRepository(supabase, isar, ref);
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final memberRepo = ref.watch(memberRepositoryProvider);
  return SupabaseProfileRepository(supabase, memberRepo);
}
