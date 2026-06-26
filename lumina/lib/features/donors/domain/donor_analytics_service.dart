import '../domain/entities/donor_entities.dart';

class DonorAnalyticsService {
  /// RFM Scoring (Recency, Frequency, Monetary)
  /// For this prototype, we'll return simple segments.
  static String getDonorSegment(Donor donor) {
    if (donor.totalDonated == null || donor.totalDonated! == 0) {
      return 'Prospect';
    }

    final total = donor.totalDonated!;
    final count = donor.donationCount ?? 0;

    if (total > 1000000) return 'Donateur Majeur (VIP)';
    if (count > 10) return 'Donateur Fidèle';
    if (count > 3) return 'Donateur Régulier';
    return 'Donateur Ponctuel';
  }

  static List<Map<String, dynamic>> getDonationDistributionByType(
    List<Donation> donations,
  ) {
    final Map<String, double> totals = {};
    for (var d in donations) {
      totals[d.donationType] = (totals[d.donationType] ?? 0) + d.amount;
    }
    return totals.entries
        .map((e) => {'type': e.key, 'amount': e.value})
        .toList();
  }
}