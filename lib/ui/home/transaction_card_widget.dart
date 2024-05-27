import 'package:flutter/material.dart';
import 'package:moneygram/di/service_locator.dart';
import 'package:moneygram/transactions/models/transaction.dart';
import 'package:moneygram/ui/home/transaction_row_header_widget.dart';
import 'package:moneygram/ui/home/transaction_row_widget.dart';
import 'package:moneygram/utils/transaction_extension.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class TransactionCardWidget extends StatefulWidget {
  final DateTime dateTime;
  final List<Transaction> transactions;
  final Function(Transaction) onTap;
  const TransactionCardWidget(
      {Key? key,
      required this.dateTime,
      required this.transactions,
      required this.onTap})
      : super(key: key);

  @override
  State<TransactionCardWidget> createState() => _TransactionCardWidgetState();
}

class _TransactionCardWidgetState extends State<TransactionCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appSecondaryColor,
      margin: EdgeInsets.only(top: 12),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TransactionRowHeaderWidget(
            dateTime: widget.dateTime,
            expense: widget.transactions.totalExpense,
            income: widget.transactions.totalIncome),
        const SizedBox(height: 8),
        _transactionList()
      ]),
    );
  }

  Widget _transactionList() {
    return ListView.builder(
        itemCount: widget.transactions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var transaction = widget.transactions[index];
          return InkWell(
            onTap: () => widget.onTap(transaction),
            child: TransactionRowWidget(
                transaction: transaction,
                accountLocalDataSource: locator.get(),
                categoryLocalDataSource: locator.get()),
          );
        });
  }
}
