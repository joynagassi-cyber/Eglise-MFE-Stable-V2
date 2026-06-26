import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/proof_image_repository.dart';
import '../../domain/image_capture_service.dart';

// Provider pour Supabase Client (Déjà existant globalement, mais accès direct ici)
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Repository Provider
final proofImageRepositoryProvider = Provider<ProofImageRepository>((ref) {
  final supabase = ref.watch(_supabaseClientProvider);
  return ProofImageRepository(supabase);
});

// Service Provider
final imageCaptureServiceProvider = Provider<ImageCaptureService>((ref) {
  final repository = ref.watch(proofImageRepositoryProvider);
  return ImageCaptureService(repository);
});