/*
------------------------------------------------------------
Course Code: MAD201-01
Project: Smart Budget Tracker Lite
Student Name: Ishmeet Singh
Student ID: A00202436
Description: Transaction model for Hive storage.
------------------------------------------------------------
*/

import 'package:hive/hive.dart';

part 'transaction_model.g.dart'; // generated adapter

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String type; // Income or Expense

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime date;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });
}
