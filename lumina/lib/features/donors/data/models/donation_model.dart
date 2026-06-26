import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/donor_entities.dart';

part 'donation_model.g.dart';

@collection
class DonationModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  String? churchId;

  @Index()
  late String donorId;

  String? campaignId;

  late double amount;
  late String currency;

  @Index()
  late DateTime donationDate;

  late String paymentMethod;
  late String donationType; // 'one-time', 'recurring'

  @Index(caseSensitive: false)
  String? notes;

  @Index()
  String? transactionId;

  late String status;

  DateTime? lastSyncedAt;

  String? jsonData;

  static DonationModel fromDomain(Donation donation) {
    return DonationModel()
      ..id = donation.id
      ..churchId = donation.churchId
      ..donorId = donation.donorId
      ..campaignId = donation.campaignId
      ..amount = donation.amount
      ..currency = donation.currency
      ..donationDate = donation.donationDate
      ..paymentMethod = donation.paymentMethod
      ..donationType = donation.donationType
      ..notes = donation.notes
      ..transactionId = donation.transactionId
      ..status = donation.status
      ..jsonData = jsonEncode(donation.toJson());
  }

  Donation toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Donation.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Donation(
      id: id,
      churchId: churchId,
      donorId: donorId,
      campaignId: campaignId,
      amount: amount,
      currency: currency,
      donationDate: donationDate,
      paymentMethod: paymentMethod,
      donationType: donationType,
      notes: notes,
      transactionId: transactionId,
      status: status,
    );
  }
}