import 'package:flutter/material.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/transactions/models/transaction.dart';
import 'package:moneygram/ui/add_transaction/actions_widget.dart';
import 'package:moneygram/ui/add_transaction/amount_widget.dart';
import 'package:moneygram/ui/add_transaction/header_widget.dart';
import 'package:moneygram/ui/add_transaction/keyboard_widget.dart';
import 'package:moneygram/ui/add_transaction/save_button.dart';
import 'package:moneygram/ui/base_screen.dart';
import 'package:moneygram/utils/analytics_helper.dart';
import 'package:moneygram/viewmodels/add_transaction_view_model.dart';

class AddTransactionPage extends StatefulWidget {
  final Transaction? transaction;
  const AddTransactionPage({Key? key, this.transaction}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  late TextEditingController notesTextController;
  late AddTransactionViewModel _model;

  @override
  void initState() {
    notesTextController = TextEditingController();
    notesTextController.addListener(() {
      _model.transactionNotes = notesTextController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<AddTransactionViewModel>(onModelReady: (model) {
      _model = model;
      _model.setValuesForTransaction(widget.transaction);
      _setViewmodelListeners();
      notesTextController.text = _model.transactionNotes ?? "";
    }, builder: (context, model, child) {
      return _content();
    });
  }

  void _setViewmodelListeners() {
    _model.exitScreenCallback = () {
      print("Callback here");
      Navigator.of(context).pop();
    };
  }

  Widget _content() {
    return GestureDetector(
      onTap: () {
        AnalyticsHelper.logEvent(
            event: AnalyticsHelper.addTransactionOutsideClicked);
        /*This method here will hide the soft keyboard.*/
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: context.appSecondaryColor,
        child: SafeArea(
          minimum: EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderWidget(isSync: _model.currentTransaction?.isSync ?? false),
              Expanded(child: AmountWidget(amount: _model.amount)),
              ActionsWidget(notesTextController: notesTextController),
              KeyboardWidget(
                  onBackPress: onBackspacePress, onKeyPress: onKeyTap),
              SaveButton(
                  isEnable: _model.isSaveButtonEnable, onTap: _onSaveButtonTap)
            ],
          ),
        ),
      ),
    );
  }

  void _onSaveButtonTap() {
    AnalyticsHelper.logEvent(event: AnalyticsHelper.addTransactionSaveClicked);
    if (_model.validate()) {
      _model.addTransaction();
      Navigator.of(context).pop();
    }
  }

  void onKeyTap(val) {
    var amount = _model.amount ?? "";
    setState(() {
      amount = amount + val;
      _model.amount = amount;
    });
  }

  void onBackspacePress() {
    var amount = _model.amount ?? "";
    if (amount.isEmpty) {
      return;
    }

    setState(() {
      amount = amount.substring(0, amount.length - 1);
      _model.amount = amount;
    });
  }
}
