import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../db/db_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  const AddTransactionScreen({this.transaction, Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _type = 'Expense';
  String _category = 'General';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = ['General', 'Food', 'Transport', 'Salary', 'Shopping', 'Bills'];

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _type = widget.transaction!.type;
      _category = widget.transaction!.category;
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter valid title and amount')));
      return;
    }

    final txn = TransactionModel(
      title: title,
      amount: amount,
      type: _type,
      category: _category,
      date: _selectedDate,
    );

    if (widget.transaction == null) {
      await DBHelper.addTransaction(txn);
    } else {
      widget.transaction!
        ..title = txn.title
        ..amount = txn.amount
        ..type = txn.type
        ..category = txn.category
        ..date = txn.date;
      await DBHelper.updateTransaction(widget.transaction!);
    }

    Navigator.pop(context, true); // return true to refresh
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _deleteTransaction() async {
    if (widget.transaction != null) {
      await DBHelper.deleteTransaction(widget.transaction!);
      Navigator.pop(context, true); // return true to refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Type:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _type,
                  items: ['Income', 'Expense'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _type = val);
                  },
                ),
                const SizedBox(width: 24),
                const Text('Category:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _category,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Date:'),
                const SizedBox(width: 8),
                Text(DateFormat.yMMMd().format(_selectedDate)),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _pickDate, child: const Text('Pick Date')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: _saveTransaction, child: const Text('Save'))),
                const SizedBox(width: 8),
                if (isEditing)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _deleteTransaction,
                      child: const Text('Delete'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
