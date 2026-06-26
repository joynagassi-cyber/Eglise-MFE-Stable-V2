import 'package:lumina/features/donors/data/models/donor_models.dart';

abstract class IDonorRepository {
  Future<List<Donor>> getDonors({required String? churchId});
  Future<Donor> getDonorById(String id);
  Future<void> saveDonor(Donor donor, String? churchId);
  Future<List<Donation>> getDonationsByDonor(String donorId);
  Future<void> saveDonation(Donation donation, String? churchId);
  Future<List<DonationCampaign>> getDonationCampaigns(
      {required String? churchId});
  Future<void> saveDonationCampaign(
      DonationCampaign campaign, String? churchId);
  Future<Map<String, dynamic>> getDonorStats({required String? churchId});
}