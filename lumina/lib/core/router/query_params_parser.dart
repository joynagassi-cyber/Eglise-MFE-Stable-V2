// lib/core/router/query_params_parser.dart
//
// Système de parsing typé pour les query parameters.

abstract class QueryParams {
  const QueryParams();
  // Factory pour créer l'objet à partir d'une Map de query params
  static T fromMap<T extends QueryParams>(Map<String, String> params, T Function(Map<String, String>) creator) {
    return creator(params);
  }
}

/// Exemple pour la route de donateur : /donors/record-donation?donorId=...
class DonationQueryParams extends QueryParams {
  final String? donorId;
  final String? amount;
  final String? date;

  DonationQueryParams({this.donorId, this.amount, this.date});

  factory DonationQueryParams.fromUri(Map<String, String> params) {
    return DonationQueryParams(
      donorId: params['donorId'],
      amount: params['amount'],
      date: params['date'],
    );
  }
}

/// Exemple pour les filtres de communauté : /communaute?filter=birthdays
class CommunityQueryParams extends QueryParams {
  final String? filter;

  CommunityQueryParams({this.filter});

  factory CommunityQueryParams.fromUri(Map<String, String> params) {
    return CommunityQueryParams(
      filter: params['filter'],
    );
  }
}