/*
------------------------------------------------------------
Course Code: MAD201-01
Project: Smart Budget Tracker Lite
Student Name: Ishmeet Singh
Student ID: A00202436
Description: Displays all transactions in a list, allows edit/delete.
------------------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';
import '../utils/shared_prefs_helper.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
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

  void _editTransaction(TransactionModel txn) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTransactionScreen(transaction: txn)),
    );

    if (result == true) _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final currency = SharedPrefsHelper.getCurrency();
    final fmt = NumberFormat.currency(symbol: '$currency ');

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions List')),
      body: _transactions.isEmpty
          ? const Center(child: Text('No transactions recorded yet.'))
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final txn = _transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      txn.type == 'Income' ? Icons.arrow_downward : Icons.arrow_upward,
                      color: txn.type == 'Income' ? Colors.green : Colors.red,
                    ),
                    title: Text(txn.title),
                    subtitle: Text('${txn.category} • ${DateFormat.yMMMd().format(txn.date)}'),
                    trailing: Text(
                      fmt.format(txn.amount),
                      style: TextStyle(
                        color: txn.type == 'Income' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _editTransaction(txn),
                  ),
                );
              },
            ),
    );
  }
}
