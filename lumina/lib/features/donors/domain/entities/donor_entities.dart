import 'package:equatable/equatable.dart';

class Donor extends Equatable {
  final String id;
  final String? churchId;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? organizationName;
  final String? email;
  final String? phone;
  final String? address;
  final String type; // 'individual' or 'organization'
  final double? totalDonated;
  final int? donationCount;
  final DateTime? lastDonationDate;
  final bool isActive;
  final bool wantsReceipt;
  final Map<String, dynamic>? metadata;

  const Donor({
    required this.id,
    this.churchId,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.organizationName,
    this.email,
    this.phone,
    this.address,
    required this.type,
    this.totalDonated,
    this.donationCount,
    this.lastDonationDate,
    this.isActive = true,
    this.wantsReceipt = true,
    this.metadata,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      id: json['id'] as String? ?? json['donor_id'] as String? ?? '',
      churchId: json['church_id'] as String?,
      displayName: json['display_name'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      organizationName: json['organization_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      type: json['type'] as String? ?? 'individual',
      totalDonated: (json['total_donated'] as num?)?.toDouble(),
      donationCount: json['donation_count'] as int?,
      lastDonationDate: json['last_donation_date'] != null
          ? DateTime.parse(json['last_donation_date'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      wantsReceipt: json['wants_receipt'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'organization_name': organizationName,
      'email': email,
      'phone': phone,
      'address': address,
      'type': type,
      'total_donated': totalDonated,
      'donation_count': donationCount,
      'last_donation_date': lastDonationDate?.toIso8601String(),
      'is_active': isActive,
      'wants_receipt': wantsReceipt,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
        id,
        churchId,
        type,
        firstName,
        lastName,
        organizationName,
        email,
        phone,
        address,
        totalDonated,
        donationCount,
        lastDonationDate,
        isActive,
        wantsReceipt,
        metadata,
      ];
}

class Donation extends Equatable {
  final String id;
  final String? churchId;
  final String donorId;
  final String? campaignId;
  final double amount;
  final String currency;
  final DateTime donationDate;
  final String paymentMethod;
  final String donationType; // 'one-time', 'recurring'
  final String? notes;
  final String? transactionId;
  final String status;

  const Donation({
    required this.id,
    this.churchId,
    required this.donorId,
    this.campaignId,
    required this.amount,
    this.currency = 'XAF',
    required this.donationDate,
    this.paymentMethod = 'cash',
    required this.donationType,
    this.notes,
    this.transactionId,
    this.status = 'completed',
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'] as String? ?? '',
      churchId: json['church_id'] as String?,
      donorId: json['donor_id'] as String? ?? '',
      campaignId: json['campaign_id'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'XAF',
      donationDate: json['donation_date'] != null
          ? DateTime.parse(json['donation_date'] as String)
          : DateTime.now(),
      paymentMethod: json['payment_method'] as String? ?? 'cash',
      donationType: json['donation_type'] as String? ?? 'one-time',
      notes: json['notes'] as String?,
      transactionId: json['transaction_id'] as String?,
      status: json['status'] as String? ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'donor_id': donorId,
      'campaign_id': campaignId,
      'amount': amount,
      'currency': currency,
      'donation_date': donationDate.toIso8601String(),
      'payment_method': paymentMethod,
      'donation_type': donationType,
      'notes': notes,
      'transaction_id': transactionId,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
        id,
        churchId,
        donorId,
        campaignId,
        amount,
        currency,
        donationDate,
        paymentMethod,
        donationType,
        notes,
        transactionId,
        status,
      ];
}

class DonationCampaign extends Equatable {
  final String id;
  final String? churchId;
  final String title;
  final String description;
  final double goalAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  const DonationCampaign({
    required this.id,
    this.churchId,
    required this.title,
    required this.description,
    required this.goalAmount,
    this.currentAmount = 0.0,
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  factory DonationCampaign.fromJson(Map<String, dynamic> json) {
    return DonationCampaign(
      id: json['id'] as String? ?? '',
      churchId: json['church_id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      goalAmount: (json['goal_amount'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (json['current_amount'] as num?)?.toDouble() ?? 0.0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'title': title,
      'description': description,
      'goal_amount': goalAmount,
      'current_amount': currentAmount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [
        id,
        churchId,
        title,
        description,
        goalAmount,
        currentAmount,
        startDate,
        endDate,
        isActive,
      ];
}