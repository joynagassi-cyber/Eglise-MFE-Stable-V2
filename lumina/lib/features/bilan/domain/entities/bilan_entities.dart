/// BILAN entities and value objects
library;

import 'package:equatable/equatable.dart';

/// Period type for BILAN reports
enum BilanPeriodType { today, week, month, quarter, ytd, custom }

class BilanGroupSummary extends Equatable {
  final String groupId;
  final String groupName;
  final double income;
  final double expense;
  final double net;
  final int txCount;
  final double? percentOfTotal;

  const BilanGroupSummary({
    required this.groupId,
    required this.groupName,
    required this.income,
    required this.expense,
    required this.net,
    required this.txCount,
    this.percentOfTotal,
  });

  factory BilanGroupSummary.fromJson(Map<String, dynamic> json) =>
      BilanGroupSummary(
        groupId: json['groupId'] as String? ?? json['id'] as String? ?? '',
        groupName:
            json['groupName'] as String? ?? json['name'] as String? ?? '',
        income: (json['income'] ?? 0).toDouble(),
        expense: (json['expense'] ?? 0).toDouble(),
        net: (json['net'] ?? 0).toDouble(),
        txCount: json['txCount'] ?? json['transaction_count'] ?? 0,
        percentOfTotal: (json['percentOfTotal'] as num?)?.toDouble(),
      );

  BilanGroupSummary copyWith({
    String? groupId,
    String? groupName,
    double? income,
    double? expense,
    double? net,
    int? txCount,
    double? percentOfTotal,
  }) {
    return BilanGroupSummary(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      net: net ?? this.net,
      txCount: txCount ?? this.txCount,
      percentOfTotal: percentOfTotal ?? this.percentOfTotal,
    );
  }

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'groupName': groupName,
        'income': income,
        'expense': expense,
        'net': net,
        'txCount': txCount,
        'percentOfTotal': percentOfTotal,
      };

  @override
  List<Object?> get props => [
        groupId,
        groupName,
        income,
        expense,
        net,
        txCount,
        percentOfTotal,
      ];
}

class ConsolidatedBilan extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final double internalEliminated;
  final int txCount;
  final int sealedCount;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const ConsolidatedBilan({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.internalEliminated,
    required this.txCount,
    this.sealedCount = 0,
    this.periodStart,
    this.periodEnd,
  });

  factory ConsolidatedBilan.fromJson(Map<String, dynamic> json) =>
      ConsolidatedBilan(
        totalIncome: (json['totalIncome'] ?? 0).toDouble(),
        totalExpense: (json['totalExpense'] ?? 0).toDouble(),
        netBalance: (json['netBalance'] ?? 0).toDouble(),
        internalEliminated: (json['internalEliminated'] ?? 0).toDouble(),
        txCount: json['txCount'] ?? json['transaction_count'] ?? 0,
        sealedCount: json['sealedCount'] ?? 0,
        periodStart: json['periodStart'] != null
            ? DateTime.parse(json['periodStart'])
            : null,
        periodEnd: json['periodEnd'] != null
            ? DateTime.parse(json['periodEnd'])
            : null,
      );

  ConsolidatedBilan copyWith({
    double? totalIncome,
    double? totalExpense,
    double? netBalance,
    double? internalEliminated,
    int? txCount,
    int? sealedCount,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    return ConsolidatedBilan(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netBalance: netBalance ?? this.netBalance,
      internalEliminated: internalEliminated ?? this.internalEliminated,
      txCount: txCount ?? this.txCount,
      sealedCount: sealedCount ?? this.sealedCount,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'netBalance': netBalance,
        'internalEliminated': internalEliminated,
        'txCount': txCount,
        'sealedCount': sealedCount,
        'periodStart': periodStart?.toIso8601String(),
        'periodEnd': periodEnd?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        netBalance,
        internalEliminated,
        txCount,
        sealedCount,
        periodStart,
        periodEnd,
      ];
}

class BilanVariation extends Equatable {
  final double current;
  final double previous;
  final double percentage;

  const BilanVariation({
    required this.current,
    required this.previous,
    required this.percentage,
  });

  factory BilanVariation.fromJson(Map<String, dynamic> json) => BilanVariation(
        current: (json['current'] ?? 0).toDouble(),
        previous: (json['previous'] ?? 0).toDouble(),
        percentage: (json['percentage'] ?? 0).toDouble(),
      );

  BilanVariation copyWith({
    double? current,
    double? previous,
    double? percentage,
  }) {
    return BilanVariation(
      current: current ?? this.current,
      previous: previous ?? this.previous,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toJson() => {
        'current': current,
        'previous': previous,
        'percentage': percentage,
      };

  @override
  List<Object?> get props => [current, previous, percentage];
}

class CurrencyConfig extends Equatable {
  final String code;
  final String symbol;
  final String label;
  final bool isDefault;

  const CurrencyConfig({
    required this.code,
    required this.symbol,
    required this.label,
    this.isDefault = false,
  });

  factory CurrencyConfig.fromJson(Map<String, dynamic> json) => CurrencyConfig(
        code: json['code'] as String? ?? '',
        symbol: json['symbol'] as String? ?? '',
        label: json['label'] as String? ?? '',
        isDefault: json['isDefault'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'symbol': symbol,
        'label': label,
        'isDefault': isDefault,
      };

  @override
  List<Object?> get props => [code, symbol, label, isDefault];
}

class TransactionAnomaly extends Equatable {
  final String transactionId;
  final double amount;
  final double groupAvg;
  final double groupStddev;
  final double deviationFactor;
  final String? reason;

  const TransactionAnomaly({
    required this.transactionId,
    required this.amount,
    required this.groupAvg,
    required this.groupStddev,
    required this.deviationFactor,
    this.reason,
  });

  factory TransactionAnomaly.fromJson(Map<String, dynamic> json) =>
      TransactionAnomaly(
        transactionId: json['transactionId'] as String? ?? '',
        amount: (json['amount'] ?? 0).toDouble(),
        groupAvg: (json['groupAvg'] ?? 0).toDouble(),
        groupStddev: (json['groupStddev'] ?? 0).toDouble(),
        deviationFactor: (json['deviationFactor'] ?? 0).toDouble(),
        reason: json['reason'] as String?,
      );

  TransactionAnomaly copyWith({
    String? transactionId,
    double? amount,
    double? groupAvg,
    double? groupStddev,
    double? deviationFactor,
    String? reason,
  }) {
    return TransactionAnomaly(
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      groupAvg: groupAvg ?? this.groupAvg,
      groupStddev: groupStddev ?? this.groupStddev,
      deviationFactor: deviationFactor ?? this.deviationFactor,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'amount': amount,
        'groupAvg': groupAvg,
        'groupStddev': groupStddev,
        'deviationFactor': deviationFactor,
        'reason': reason,
      };

  @override
  List<Object?> get props => [
        transactionId,
        amount,
        groupAvg,
        groupStddev,
        deviationFactor,
        reason,
      ];
}

class ChurchBranding extends Equatable {
  final String name;
  final String? logoUrl;
  final int fontSize;
  final String fontWeight;
  final String color;

  const ChurchBranding({
    required this.name,
    this.logoUrl,
    this.fontSize = 18,
    this.fontWeight = 'bold',
    this.color = '#000000',
  });

  factory ChurchBranding.fromJson(Map<String, dynamic> json) => ChurchBranding(
        name: json['name'] as String? ?? '',
        logoUrl: json['logoUrl'] as String?,
        fontSize: json['fontSize'] as int? ?? 18,
        fontWeight: json['fontWeight'] as String? ?? 'bold',
        color: json['color'] as String? ?? '#000000',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'logoUrl': logoUrl,
        'fontSize': fontSize,
        'fontWeight': fontWeight,
        'color': color,
      };

  @override
  List<Object?> get props => [name, logoUrl, fontSize, fontWeight, color];
}

class AppThemeConfig extends Equatable {
  final String code;
  final String name;
  final String primaryColor;
  final String secondaryColor;
  final String? successColor;
  final String? warningColor;
  final String? dangerColor;
  final String? backgroundColor;
  final String? cardColor;
  final String? fontFamily;
  final int fontSizeBase;
  final bool isDefault;

  const AppThemeConfig({
    required this.code,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    this.successColor,
    this.warningColor,
    this.dangerColor,
    this.backgroundColor,
    this.cardColor,
    this.fontFamily,
    this.fontSizeBase = 14,
    this.isDefault = false,
  });

  factory AppThemeConfig.fromJson(Map<String, dynamic> json) => AppThemeConfig(
        code: json['code'] as String? ?? '',
        name: json['name'] as String? ?? '',
        primaryColor: json['primaryColor'] as String? ?? '',
        secondaryColor: json['secondaryColor'] as String? ?? '',
        successColor: json['successColor'] as String?,
        warningColor: json['warningColor'] as String?,
        dangerColor: json['dangerColor'] as String?,
        backgroundColor: json['backgroundColor'] as String?,
        cardColor: json['cardColor'] as String?,
        fontFamily: json['fontFamily'] as String?,
        fontSizeBase: json['fontSizeBase'] as int? ?? 14,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'successColor': successColor,
        'warningColor': warningColor,
        'dangerColor': dangerColor,
        'backgroundColor': backgroundColor,
        'cardColor': cardColor,
        'fontFamily': fontFamily,
        'fontSizeBase': fontSizeBase,
        'isDefault': isDefault,
      };

  @override
  List<Object?> get props => [
        code,
        name,
        primaryColor,
        secondaryColor,
        successColor,
        warningColor,
        dangerColor,
        backgroundColor,
        cardColor,
        fontFamily,
        fontSizeBase,
        isDefault,
      ];
}

class BilanTransaction extends Equatable {
  final String id;
  final DateTime date;
  final String label;
  final double amount;
  final String type; // income, expense, transfer
  final String category;
  final String? groupName;
  final String? imageUrl;
  final bool isInternalTransfer;
  final String status;

  const BilanTransaction({
    required this.id,
    required this.date,
    required this.label,
    required this.amount,
    required this.type,
    required this.category,
    this.groupName,
    this.imageUrl,
    this.isInternalTransfer = false,
    this.status = 'validated',
  });

  factory BilanTransaction.fromJson(Map<String, dynamic> json) =>
      BilanTransaction(
        id: json['id'] as String? ?? '',
        date: DateTime.parse(json['date'] as String),
        label: json['label'] as String? ?? '',
        amount: (json['amount'] ?? 0).toDouble(),
        type: json['type'] as String? ?? '',
        category: json['category'] as String? ?? '',
        groupName: json['groupName'] as String?,
        imageUrl: json['imageUrl'] as String?,
        isInternalTransfer: json['isInternalTransfer'] as bool? ?? false,
        status: json['status'] as String? ?? 'validated',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'label': label,
        'amount': amount,
        'type': type,
        'category': category,
        'groupName': groupName,
        'imageUrl': imageUrl,
        'isInternalTransfer': isInternalTransfer,
        'status': status,
      };

  @override
  List<Object?> get props => [
        id,
        date,
        label,
        amount,
        type,
        category,
        groupName,
        imageUrl,
        isInternalTransfer,
        status,
      ];
}

class FecLine extends Equatable {
  final String journalCode;
  final String journalLib;
  final String ecritureNum;
  final DateTime ecritureDate;
  final String compteNum;
  final String compteLib;
  final String compauxNum;
  final String compauxLib;
  final String pieceRef;
  final DateTime pieceDate;
  final String ecritureLib;
  final double debit;
  final double credit;
  final DateTime valideDate;
  final double montantDevise;
  final String iDevise;

  const FecLine({
    required this.journalCode,
    required this.journalLib,
    required this.ecritureNum,
    required this.ecritureDate,
    required this.compteNum,
    required this.compteLib,
    required this.compauxNum,
    required this.compauxLib,
    required this.pieceRef,
    required this.pieceDate,
    required this.ecritureLib,
    required this.debit,
    required this.credit,
    required this.valideDate,
    required this.montantDevise,
    required this.iDevise,
  });

  factory FecLine.fromJson(Map<String, dynamic> json) => FecLine(
        journalCode: json['journalCode'] as String? ?? '',
        journalLib: json['journalLib'] as String? ?? '',
        ecritureNum: json['ecritureNum'] as String? ?? '',
        ecritureDate: DateTime.parse(json['ecritureDate'] as String),
        compteNum: json['compteNum'] as String? ?? '',
        compteLib: json['compteLib'] as String? ?? '',
        compauxNum: json['compauxNum'] as String? ?? '',
        compauxLib: json['compauxLib'] as String? ?? '',
        pieceRef: json['pieceRef'] as String? ?? '',
        pieceDate: DateTime.parse(json['pieceDate'] as String),
        ecritureLib: json['ecritureLib'] as String? ?? '',
        debit: (json['debit'] ?? 0).toDouble(),
        credit: (json['credit'] ?? 0).toDouble(),
        valideDate: DateTime.parse(json['valideDate'] as String),
        montantDevise: (json['montantDevise'] ?? 0).toDouble(),
        iDevise: json['iDevise'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'journalCode': journalCode,
        'journalLib': journalLib,
        'ecritureNum': ecritureNum,
        'ecritureDate': ecritureDate.toIso8601String(),
        'compteNum': compteNum,
        'compteLib': compteLib,
        'compauxNum': compauxNum,
        'compauxLib': compauxLib,
        'pieceRef': pieceRef,
        'pieceDate': pieceDate.toIso8601String(),
        'ecritureLib': ecritureLib,
        'debit': debit,
        'credit': credit,
        'valideDate': valideDate.toIso8601String(),
        'montantDevise': montantDevise,
        'iDevise': iDevise,
      };

  @override
  List<Object?> get props => [
        journalCode,
        journalLib,
        ecritureNum,
        ecritureDate,
        compteNum,
        compteLib,
        compauxNum,
        compauxLib,
        pieceRef,
        pieceDate,
        ecritureLib,
        debit,
        credit,
        valideDate,
        montantDevise,
        iDevise,
      ];
}

class BilanAuditLog extends Equatable {
  final String id;
  final String action;
  final String changedBy;
  final String? changedByRole;
  final DateTime createdAt;
  final Map<String, dynamic>? oldData;
  final Map<String, dynamic>? newData;
  final String? recordId;

  const BilanAuditLog({
    required this.id,
    required this.action,
    required this.changedBy,
    this.changedByRole,
    required this.createdAt,
    this.oldData,
    this.newData,
    this.recordId,
  });

  factory BilanAuditLog.fromJson(Map<String, dynamic> json) => BilanAuditLog(
        id: json['id'] as String? ?? '',
        action: json['action'] as String? ?? '',
        changedBy: json['changedBy'] as String? ?? '',
        changedByRole: json['changedByRole'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        oldData: json['oldData'] as Map<String, dynamic>?,
        newData: json['newData'] as Map<String, dynamic>?,
        recordId: json['recordId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'action': action,
        'changedBy': changedBy,
        'changedByRole': changedByRole,
        'createdAt': createdAt.toIso8601String(),
        'oldData': oldData,
        'newData': newData,
        'recordId': recordId,
      };

  @override
  List<Object?> get props => [
        id,
        action,
        changedBy,
        changedByRole,
        createdAt,
        oldData,
        newData,
        recordId,
      ];
}

class BilanFinancialSettings extends Equatable {
  final double anomalySigmaThreshold;
  final bool eliminateInternalTransfers;
  final String currencyCode;

  const BilanFinancialSettings({
    this.anomalySigmaThreshold = 2.0,
    this.eliminateInternalTransfers = true,
    this.currencyCode = 'XOF',
  });

  factory BilanFinancialSettings.fromJson(Map<String, dynamic> json) =>
      BilanFinancialSettings(
        anomalySigmaThreshold:
            (json['anomalySigmaThreshold'] ?? 2.0).toDouble(),
        eliminateInternalTransfers:
            json['eliminateInternalTransfers'] as bool? ?? true,
        currencyCode: json['currencyCode'] as String? ?? 'XOF',
      );

  BilanFinancialSettings copyWith({
    double? anomalySigmaThreshold,
    bool? eliminateInternalTransfers,
    String? currencyCode,
  }) {
    return BilanFinancialSettings(
      anomalySigmaThreshold:
          anomalySigmaThreshold ?? this.anomalySigmaThreshold,
      eliminateInternalTransfers:
          eliminateInternalTransfers ?? this.eliminateInternalTransfers,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'anomalySigmaThreshold': anomalySigmaThreshold,
        'eliminateInternalTransfers': eliminateInternalTransfers,
        'currencyCode': currencyCode,
      };

  @override
  List<Object?> get props => [
        anomalySigmaThreshold,
        eliminateInternalTransfers,
        currencyCode,
      ];
}

class BilanApprovalRequest extends Equatable {
  final String id;
  final String transactionId;
  final double requestedAmount;
  final String status;
  final int requiredSignatures;
  final int currentSignatures;
  final DateTime createdAt;

  const BilanApprovalRequest({
    required this.id,
    required this.transactionId,
    required this.requestedAmount,
    required this.status,
    required this.requiredSignatures,
    required this.currentSignatures,
    required this.createdAt,
  });

  factory BilanApprovalRequest.fromJson(Map<String, dynamic> json) =>
      BilanApprovalRequest(
        id: json['id'] as String? ?? '',
        transactionId: json['transactionId'] as String? ?? '',
        requestedAmount: (json['requestedAmount'] ?? 0).toDouble(),
        status: json['status'] as String? ?? 'pending',
        requiredSignatures: json['requiredSignatures'] as int? ?? 1,
        currentSignatures: json['currentSignatures'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'transactionId': transactionId,
        'requestedAmount': requestedAmount,
        'status': status,
        'requiredSignatures': requiredSignatures,
        'currentSignatures': currentSignatures,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        transactionId,
        requestedAmount,
        status,
        requiredSignatures,
        currentSignatures,
        createdAt,
      ];
}

class ReportSnapshot extends Equatable {
  final String id;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Map<String, dynamic> data;
  final String signature;
  final String sealedBy;
  final DateTime sealedAt;

  const ReportSnapshot({
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    required this.data,
    required this.signature,
    required this.sealedBy,
    required this.sealedAt,
  });

  factory ReportSnapshot.fromJson(Map<String, dynamic> json) => ReportSnapshot(
        id: json['id'] as String? ?? '',
        periodStart: DateTime.parse(json['periodStart'] as String),
        periodEnd: DateTime.parse(json['periodEnd'] as String),
        data: json['data'] as Map<String, dynamic>? ?? {},
        signature: json['signature'] as String? ?? '',
        sealedBy: json['sealedBy'] as String? ?? '',
        sealedAt: DateTime.parse(json['sealedAt'] as String),
      );

  ReportSnapshot copyWith({
    String? id,
    DateTime? periodStart,
    DateTime? periodEnd,
    Map<String, dynamic>? data,
    String? signature,
    String? sealedBy,
    DateTime? sealedAt,
  }) {
    return ReportSnapshot(
      id: id ?? this.id,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      data: data ?? this.data,
      signature: signature ?? this.signature,
      sealedBy: sealedBy ?? this.sealedBy,
      sealedAt: sealedAt ?? this.sealedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'periodStart': periodStart.toIso8601String(),
        'periodEnd': periodEnd.toIso8601String(),
        'data': data,
        'signature': signature,
        'sealedBy': sealedBy,
        'sealedAt': sealedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        periodStart,
        periodEnd,
        data,
        signature,
        sealedBy,
        sealedAt,
      ];
}

class BilanHeatmapPoint extends Equatable {
  final int dayOfWeek;
  final int hourOfDay;
  final int txCount;

  const BilanHeatmapPoint({
    required this.dayOfWeek,
    required this.hourOfDay,
    required this.txCount,
  });

  factory BilanHeatmapPoint.fromJson(Map<String, dynamic> json) {
    return BilanHeatmapPoint(
      dayOfWeek: json['day_of_week'] as int? ?? 0,
      hourOfDay: json['hour_of_day'] as int? ?? 0,
      txCount: json['tx_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'hour_of_day': hourOfDay,
      'tx_count': txCount,
    };
  }

  @override
  List<Object?> get props => [dayOfWeek, hourOfDay, txCount];
}