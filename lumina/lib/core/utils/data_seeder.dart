import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../../features/finance/domain/entities/finance_transaction.dart';
import '../../features/finance/domain/entities/enums/transaction_type.dart';
import '../../features/finance/domain/entities/enums/payment_method.dart';
import '../../features/finance/domain/entities/enums/transaction_status.dart';
import '../../features/finance/domain/repositories/i_finance_repository.dart';

class DataSeeder {
  static Future<void> seedTransactions(IFinanceRepository repository) async {
    try {
      final file = File(r'c:\Users\joyda\Downloads\transactions_eglise.json');
      if (!await file.exists()) {
        debugPrint('Seed file not found at ${file.path}');
        return;
      }
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString);

      final transactionsMap = data['transactions'] as Map<String, dynamic>;

      for (final monthKey in transactionsMap.keys) {
        final list = transactionsMap[monthKey] as List<dynamic>;
        for (final item in list) {
          final dateStr = item['date'] as String;
          // dateStr is DD/MM/YYYY
          final parts = dateStr.split('/');
          final date = DateTime(
              int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

          final serviceType = item['type_service'] as String?;
          final notes = item['notes'] as String?;

          Future<void> addTx(double amount, String category) async {
            if (amount > 0) {
              final tx = FinanceTransaction(
                id: const Uuid().v4(),
                amount: amount,
                date: date,
                description: serviceType ?? category,
                category: category,
                type: TransactionType.income,
                paymentMethod: PaymentMethod.cash,
                status: TransactionStatus.validated,
                notes: notes,
                currency: 'XAF',
              );
              await repository.saveTransaction(tx);
            }
          }

          await addTx((item['offrandes_fcfa'] ?? 0).toDouble(), 'Offrandes');
          await addTx((item['dimes_fcfa'] ?? 0).toDouble(), 'Dîmes');
          await addTx((item['terrain_fcfa'] ?? 0).toDouble(), 'Achat Terrain');
          await addTx((item['chorale_fcfa'] ?? 0).toDouble(), 'Chorale');
        }
      }
      debugPrint('Seeding completed successfully!');
    } catch (e) {
      debugPrint('Error seeding: $e');
    }
  }
}
