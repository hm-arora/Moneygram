import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneygram/transactions/models/transaction.dart';

abstract class TransactionManagerLocalDataSource {
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction,
      {bool forceOverride = false});
  Future<List<Transaction>> transactions();
  Future<List<Transaction>> filteredTransactions(DateTimeRange dateTimeRange);
  Future<void> clearTransactions();
  Future<void> clearTransaction(int key);
  Box<Transaction> getBox();
  Future<Transaction?> fetchTransactionFromId(int transactionId);
}
