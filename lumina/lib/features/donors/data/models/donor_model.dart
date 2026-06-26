import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/donor_entities.dart';

part 'donor_model.g.dart';

@collection
class DonorModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  String? churchId;

  @Index(caseSensitive: false)
  late String displayName;

  @Index(caseSensitive: false)
  String? firstName;

  @Index(caseSensitive: false)
  String? lastName;

  @Index(caseSensitive: false)
  String? organizationName;

  @Index(caseSensitive: false)
  String? email;

  String? phone;
  String? address;

  @Index()
  late String type; // 'individual' or 'organization'

  double? totalDonated;
  int? donationCount;
  DateTime? lastDonationDate;

  bool isActive = true;
  bool wantsReceipt = true;

  DateTime? lastSyncedAt;

  String? jsonData;

  static DonorModel fromDomain(Donor donor) {
    return DonorModel()
      ..id = donor.id
      ..churchId = donor.churchId
      ..displayName = donor.displayName
      ..firstName = donor.firstName
      ..lastName = donor.lastName
      ..organizationName = donor.organizationName
      ..email = donor.email
      ..phone = donor.phone
      ..address = donor.address
      ..type = donor.type
      ..totalDonated = donor.totalDonated
      ..donationCount = donor.donationCount
      ..lastDonationDate = donor.lastDonationDate
      ..isActive = donor.isActive
      ..wantsReceipt = donor.wantsReceipt
      ..jsonData = jsonEncode(donor.toJson());
  }

  Donor toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Donor.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Donor(
      id: id,
      churchId: churchId,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      organizationName: organizationName,
      email: email,
      phone: phone,
      address: address,
      type: type,
      totalDonated: totalDonated,
      donationCount: donationCount,
      lastDonationDate: lastDonationDate,
      isActive: isActive,
      wantsReceipt: wantsReceipt,
    );
  }
}