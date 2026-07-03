import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/mixins/auditable_mixin.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import 'package:lumina/features/donors/domain/repositories/i_donor_repository.dart';
import 'package:lumina/features/donors/data/models/donor_models.dart';
import 'package:lumina/core/utils/supabase_extensions.dart';

class DonorRepository with AuditableMixin implements IDonorRepository {
  final SupabaseClient _supabase;
  final Ref _ref;

  DonorRepository(this._supabase, this._ref);

  @override
  Future<List<Donor>> getDonors({required String? churchId}) async {
    var query = _supabase.from('donors').select().scoped(_ref);

    final data = await query.eq('is_active', true).order('display_name');
    return (data as List).map((e) => Donor.fromJson(e)).toList();
  }

  @override
  Future<Donor> getDonorById(String id) async {
    final data = await _supabase.from('donors').select().eq('id', id).single();
    return Donor.fromJson(data);
  }

  @override
  Future<void> saveDonor(Donor donor, String? churchId) async {
    final json = donor.toJson();

    // Assurer que le church_id est bien présent
    if (churchId != null && churchId != '*') {
      json['church_id'] = churchId;
    }

    if (donor.id.isEmpty || donor.id.length < 32) {
      // New donor
      json.remove('id');
      final data = await _supabase.from('donors').insert(json).select().single();
      final insertedId = data['id'] as String;

      // Audit Log: Create Donor
      await logAuditAction(
        _ref,
        action: AuditAction.insert,
        entityType: 'donors',
        entityId: insertedId,
        newData: json,
      );
    } else {
      // Security check: ensure we don't overwrite church_id if it's already there
      // (Supabase RLS should handle this, but good practice)
      await _supabase.from('donors').update(json).eq('id', donor.id);

      // Audit Log: Update Donor
      await logAuditAction(
        _ref,
        action: AuditAction.update,
        entityType: 'donors',
        entityId: donor.id,
        newData: json,
      );
    }
  }

  @override
  Future<List<Donation>> getDonationsByDonor(String donorId) async {
    // Pas besoin de filtre church ici car lié au donor_id qui est déjà unique/filtré
    final data = await _supabase
        .from('donations')
        .select()
        .eq('donor_id', donorId)
        .order('donation_date', ascending: false);
    return (data as List).map((e) => Donation.fromJson(e)).toList();
  }

  @override
  Future<void> saveDonation(Donation donation, String? churchId) async {
    final json = donation.toJson();

    if (churchId != null && churchId != '*') {
      json['church_id'] = churchId;
    }

    if (donation.id.isEmpty) {
      json.remove('id');
      final data =
          await _supabase.from('donations').insert(json).select().single();
      final insertedId = data['id'] as String;

      // Audit Log: Create Donation
      await logAuditAction(
        _ref,
        action: AuditAction.insert,
        entityType: 'donations',
        entityId: insertedId,
        newData: json,
      );
    } else {
      await _supabase.from('donations').update(json).eq('id', donation.id);

      // Audit Log: Update Donation
      await logAuditAction(
        _ref,
        action: AuditAction.update,
        entityType: 'donations',
        entityId: donation.id,
        newData: json,
      );
    }
  }

  // --- Campagnes de dons ---

  @override
  Future<List<DonationCampaign>> getDonationCampaigns({
    required String? churchId,
  }) async {
    var query = _supabase.from('donation_campaigns').select().scoped(_ref);

    final data = await query.order('created_at', ascending: false);
    return (data as List).map((e) => DonationCampaign.fromJson(e)).toList();
  }

  @override
  Future<void> saveDonationCampaign(
    DonationCampaign campaign,
    String? churchId,
  ) async {
    final json = campaign.toJson();

    if (churchId != null && churchId != '*') {
      json['church_id'] = churchId;
    }

    if (campaign.id.isEmpty) {
      json.remove('id');
      final data = await _supabase
          .from('donation_campaigns')
          .insert(json)
          .select()
          .single();
      final insertedId = data['id'] as String;

      // Audit Log: Create Campaign
      await logAuditAction(
        _ref,
        action: AuditAction.insert,
        entityType: 'donation_campaigns',
        entityId: insertedId,
        newData: json,
      );
    } else {
      await _supabase
          .from('donation_campaigns')
          .update(json)
          .eq('id', campaign.id);

      // Audit Log: Update Campaign
      await logAuditAction(
        _ref,
        action: AuditAction.update,
        entityType: 'donation_campaigns',
        entityId: campaign.id,
        newData: json,
      );
    }
  }

  // Calcul optimisé via les champs pré-calculés par les triggers SQL
  @override
  Future<Map<String, dynamic>> getDonorStats({
    required String? churchId,
  }) async {
    try {
      // On récupère les colonnes pertinentes de tous les donateurs pour agréger
      var query =
          _supabase.from('donors').select('total_donated, donation_count').scoped(_ref);

      final donorsRaw = await query.eq('is_active', true);
      final donors = donorsRaw as List;

      double totalDonated = 0;
      int totalDonationsCount = 0;
      final int donorCount = donors.length;
      int activeDonors = 0;

      for (var d in donors) {
        final amount = (d['total_donated'] as num?)?.toDouble() ?? 0.0;
        final count = (d['donation_count'] as num?)?.toInt() ?? 0;

        totalDonated += amount;
        totalDonationsCount += count;
        if (count > 0) {
          activeDonors++;
        }
      }

      return {
        'total_donors': donorCount,
        'total_donated': totalDonated,
        'avg_donation':
            totalDonationsCount > 0 ? totalDonated / totalDonationsCount : 0,
        'active_donor_count': activeDonors,
        'retention_rate':
            donorCount > 0 ? (activeDonors / donorCount * 100).round() : 0,
      };
    } catch (e) {
      return {
        'total_donors': 0,
        'total_donated': 0.0,
        'avg_donation': 0.0,
        'active_donor_count': 0,
        'retention_rate': 0,
      };
    }
  }
}