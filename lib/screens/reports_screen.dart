/*
------------------------------------------------------------
Course Code: MAD201-01
Project: Smart Budget Tracker Lite
Student Name: Ishmeet Singh
Student ID: A00202436
Description: Displays totals by category and by month.
------------------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import '../models/transaction_model.dart';
import '../utils/shared_prefs_helper.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = DBHelper.getTransactions();
    final currency = SharedPrefsHelper.getCurrency();
    final fmt = NumberFormat.currency(symbol: '$currency ');

    // Calculate totals by category
    final Map<String, double> categoryTotals = {};
    for (var t in transactions) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    // Calculate totals by month
    final Map<String, double> monthTotals = {};
    for (var t in transactions) {
      final key = DateFormat.yMMM().format(t.date);
      monthTotals[key] = (monthTotals[key] ?? 0) + (t.type == 'Income' ? t.amount : -t.amount);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Summary')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text('Total by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...categoryTotals.entries.map((e) => Card(
                  child: ListTile(
                    title: Text(e.key),
                    trailing: Text(fmt.format(e.value)),
                  ),
                )),
            const SizedBox(height: 24),
            const Text('Total by Month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...monthTotals.entries.map((e) => Card(
                  child: ListTile(
                    title: Text(e.key),
                    trailing: Text(fmt.format(e.value)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
