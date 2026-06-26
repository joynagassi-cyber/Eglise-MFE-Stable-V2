import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

void main() async {
  await Supabase.initialize(
    url: 'https://vvcdmqpbwfyhkzalwdli.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2Y2RtcXBid2Z5aGt6YWx3ZGxpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMzg2MTQsImV4cCI6MjA4MzkxNDYxNH0.pXn4d00_nDLiMCnNpRqX1atp1vx2c0B-k8TLxJ9f40M',
  );

  developer.log('🔐 Connexion...\n');

  try {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: 'joynagassi@gmail.com',
      password: 'Joynagassi@2025',
    );

    if (response.session != null) {
      developer.log('✅ Connexion réussie!\n');
      developer.log('JWT TOKEN:');
      developer.log('─' * 80);
      developer.log(response.session!.accessToken);
      developer.log('─' * 80);
    } else {
      developer.log('❌ Pas de session');
    }
  } catch (e) {
    developer.log('❌ Erreur: $e');
  }
}
