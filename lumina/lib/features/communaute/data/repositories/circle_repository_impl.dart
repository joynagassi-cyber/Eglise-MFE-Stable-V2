import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/circle.dart';
import '../../domain/repositories/i_circle_repository.dart';
import '../../../../core/utils/app_date_time.dart';

class CircleRepositoryImpl implements ICircleRepository {
  final SupabaseClient _supabase;
  final _logger = Logger();

  CircleRepositoryImpl(this._supabase);

  @override
  Future<List<Circle>> getCircles({required String churchId}) async {
    try {
      final List<dynamic> data = await _supabase
          .from('circles')
          .select()
          .eq('church_id', churchId)
          .order('name');

      return data
          .map((json) => Circle.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      _logger.e('Failed to fetch circles', error: e);
      return [];
    }
  }

  @override
  Future<Circle?> getCircleById(String id) async {
    try {
      final data =
          await _supabase.from('circles').select().eq('id', id).single();
      return Circle.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      _logger.e('Failed to fetch circle $id', error: e);
      return null;
    }
  }

  @override
  Future<Circle> createCircle(Circle circle) async {
    final json = circle.toJson();
    json.remove('id');
    json.remove('created_at');
    json.remove('updated_at');

    final data = await _supabase.from('circles').insert(json).select().single();
    return Circle.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<Circle> updateCircle(Circle circle) async {
    final json = circle.toJson();
    json.remove('created_at');
    json['updated_at'] = AppDateTime.nowIso();

    final data = await _supabase
        .from('circles')
        .update(json)
        .eq('id', circle.id)
        .select()
        .single();
    return Circle.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> deleteCircle(String id) async {
    await _supabase.from('circles').delete().eq('id', id);
  }

  @override
  Future<List<CircleMember>> getCircleMembers(String circleId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('circle_members')
          .select()
          .eq('circle_id', circleId)
          .order('joined_at');

      return data
          .map((json) => CircleMember.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      _logger.e('Failed to fetch circle members', error: e);
      return [];
    }
  }

  @override
  Future<void> addMemberToCircle({
    required String circleId,
    required String memberId,
    String role = 'member',
  }) async {
    await _supabase.from('circle_members').upsert({
      'circle_id': circleId,
      'member_id': memberId,
      'role': role,
      'joined_at': AppDateTime.nowIso(),
    });

    // Increment member count
    try {
      await _supabase.rpc('increment_circle_member_count', params: {
        'p_circle_id': circleId,
      });
    } catch (e) {
      _logger.w('Fallback: increment_circle_member_count RPC failed', error: e);
    }
  }

  @override
  Future<void> removeMemberFromCircle({
    required String circleId,
    required String memberId,
  }) async {
    await _supabase
        .from('circle_members')
        .delete()
        .eq('circle_id', circleId)
        .eq('member_id', memberId);
  }

  @override
  Future<List<Circle>> searchCircles({
    required String churchId,
    required String query,
  }) async {
    try {
      final List<dynamic> data = await _supabase
          .from('circles')
          .select()
          .eq('church_id', churchId)
          .ilike('name', '%$query%')
          .order('name');

      return data
          .map((json) => Circle.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      _logger.e('Failed to search circles', error: e);
      return [];
    }
  }
}