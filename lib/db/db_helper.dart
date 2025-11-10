/*
------------------------------------------------------------
Course Code: MAD201-01
Project: Smart Budget Tracker Lite
Student Name: Ishmeet Singh
Student ID: A00202436
Description: Hive helper to manage transactions in local
storage for desktop/browser.
------------------------------------------------------------
*/

import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class DBHelper {
  static const String boxName = 'transactionsBox';

  /// Open Hive box (call this once in main)
  static Future<void> init() async {
    Hive.registerAdapter(TransactionModelAdapter());
    await Hive.openBox<TransactionModel>(boxName);
  }

  /// Add transaction
  static Future<void> addTransaction(TransactionModel txn) async {
    final box = Hive.box<TransactionModel>(boxName);
    await box.add(txn);
  }

  /// Update transaction (HiveObject allows update)
  static Future<void> updateTransaction(TransactionModel txn) async {
    await txn.save();
  }

  /// Delete transaction
  static Future<void> deleteTransaction(TransactionModel txn) async {
    await txn.delete();
  }

  /// Get all transactions
  static List<TransactionModel> getTransactions() {
    final box = Hive.box<TransactionModel>(boxName);
    return box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first
  }
}
