/*
------------------------------------------------------------
Course Code: MAD201-01
Project: Smart Budget Tracker Lite
Student Name: Ishmeet Singh
Student ID: A00202436
Description: HomeScreen shows total income, expense, balance, 
and provides buttons to navigate to Add, Transactions List, Reports, and Settings screens.
------------------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';
import 'settings_screen.dart';
import 'transactions_list_screen.dart';
import 'reports_screen.dart';
import '../utils/shared_prefs_helper.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const HomeScreen({required this.onThemeChanged, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    _transactions = DBHelper.getTransactions();
    setState(() {});
  }

  void _goToAddTransaction([TransactionModel? txn]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTransactionScreen(transaction: txn)),
    );

    if (result == true) _loadTransactions(); // refresh list after add/edit/delete
  }

  void _goToTransactionsList() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransactionsListScreen()),
    );
    if (result == true) _loadTransactions(); // refresh
  }

  void _goToReports() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportsScreen()),
    );
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(onThemeChanged: widget.onThemeChanged),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = SharedPrefsHelper.getCurrency();
    double totalIncome = 0;
    double totalExpense = 0;

    for (var t in _transactions) {
      if (t.type == 'Income') totalIncome += t.amount;
      else totalExpense += t.amount;
    }

    final balance = totalIncome - totalExpense;
    final fmt = NumberFormat.currency(symbol: '$currency ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Budget Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _goToSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Summary Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryCard('Income', fmt.format(totalIncome), Colors.green),
                _summaryCard('Expense', fmt.format(totalExpense), Colors.red),
                _summaryCard('Balance', fmt.format(balance), Colors.blue),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons
            ElevatedButton.icon(
              onPressed: () => _goToAddTransaction(),
              icon: const Icon(Icons.add),
              label: const Text('Add Transaction'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _goToTransactionsList,
              icon: const Icon(Icons.list),
              label: const Text('View Transactions'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _goToReports,
              icon: const Icon(Icons.bar_chart),
              label: const Text('View Reports & Summary'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for summary card
  Widget _summaryCard(String title, String amount, Color color) {
    return Card(
      elevation: 3,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
