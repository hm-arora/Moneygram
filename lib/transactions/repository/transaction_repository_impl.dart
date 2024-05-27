import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneygram/transactions/data_sources/transaction_local_data_source.dart';
import 'package:moneygram/transactions/models/transaction.dart';
import 'package:moneygram/transactions/repository/transaction_repository.dart';
import 'package:moneygram/ui/home/models/timeline.dart';
import 'package:moneygram/utils/currency_helper.dart';
import 'package:moneygram/utils/enum/filter_budget.dart';
import 'package:moneygram/utils/enum/transaction_type.dart';
import 'package:moneygram/utils/enum/filter_days.dart';
import 'package:moneygram/utils/time_extension.dart';
import 'package:moneygram/utils/transaction_extension.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  TransactionRepositoryImpl({
    required this.dataSource,
  });

  List<Transaction> transactionsList = [];
  final TransactionManagerLocalDataSource dataSource;

  @override
  Future<void> addTransaction(String? notes, double amount, DateTime time,
      int categoryId, int accountId, TransactionType transactionType) async {
    var transaction = Transaction(
        notes: notes,
        amount: amount,
        time: time,
        categoryId: categoryId,
        accountId: accountId,
        type: transactionType);
    await dataSource.addTransaction(transaction);
  }

  @override
  Future<Map<DateTime, List<Transaction>>> getGroupedTransactions(
      bool isRefresh, Timeline? timeline) async {
    var transactions = await fetchAndCache(isRefresh: isRefresh);
    transactions.sort((a, b) => b.time.compareTo(a.time));
    if (timeline != null) {
      transactions = transactions.isFilterTimeBetween(
        DateTimeRange(start: timeline.startTime, end: timeline.endTime));
    }
    final Map<DateTime, List<Transaction>> groupedExpense =
        transactions.groupByDateTime(FilterBudget.daily);
    return groupedExpense;
  }

  @override
  Future<List<Transaction>> getAllTransactions(bool isRefresh) async {
    final expenses = await fetchAndCache(isRefresh: isRefresh);
    return expenses;
  }

  @override
  Future<void> clearTransaction(int transactionId) async {
    dataSource.clearTransaction(transactionId);
  }

  @override
  Future<void> clearTransactions() async {
    dataSource.clearTransactions();
  }

  @override
  Future<Transaction?> fetchTransactionFromId(int transactionId) {
    return dataSource.fetchTransactionFromId(transactionId);
  }

  @override
  Future<String> filterTransactionTotal(FilterDays filterDays) async {
    final List<Transaction> transactions = await fetchAndCache();
    transactions.sort((a, b) => b.time.compareTo(a.time));
    final total = transactions
        .where((element) {
          final int days = element.time.daysDifference;
          return filterDays.filterDate(days);
        })
        .map((e) => e.amount)
        .fold<double>(0, (previousValue, element) => previousValue + element);
    return CurrencyHelper.formattedCurrency(total);
  }

  @override
  Future<String> totalTransactions(
      TransactionType type, Timeline timeline) async {
    List<Transaction> transactions = await fetchAndCache();
    transactions = transactions.isFilterTimeBetween(
        DateTimeRange(start: timeline.startTime, end: timeline.endTime));
    double total = 0;
    if (type == TransactionType.expense) {
      total = transactions.totalExpense;
    } else {
      total = transactions.totalIncome;
    }
    return CurrencyHelper.formattedCurrency(total);
    // transactions.sort((a, b) => b.time.compareTo(a.time));
    // double total = 0;
    // for (var transaction in transactions) {
    //   if (transaction.type == type &&
    //       timeline.isDateInRange(transaction.time)) {
    //     total += transaction.amount;
    //   }
    // }
    // // final total = transactions
    // //     .where((element) => element.type == type)
    // //     .map((e) => e.amount)
    // //     .fold<double>(0, (previousValue, element) => previousValue + element);
    // return CurrencyHelper.formattedCurrency(total);
  }

  Future<List<Transaction>> fetchAndCache({bool isRefresh = false}) async {
    if (transactionsList.isEmpty || isRefresh) {
      transactionsList = await dataSource.transactions();
    }
    return transactionsList;
  }

  @override
  Future<void> updateTransaction(Transaction transaction,
      {bool forceOverride = false}) async {
    await dataSource.updateTransaction(transaction,
        forceOverride: forceOverride);
  }

  @override
  Box<Transaction> getBox() {
    return dataSource.getBox();
  }
}
