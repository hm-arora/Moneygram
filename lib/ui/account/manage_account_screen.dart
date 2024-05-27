import 'package:flutter/material.dart';
import 'package:moneygram/account/model/account.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/ui/account/add_edit_account_screen.dart';
import 'package:moneygram/ui/base_screen.dart';
import 'package:moneygram/utils/analytics_helper.dart';
import 'package:moneygram/utils/custom_text_style.dart';
import 'package:moneygram/viewmodels/manage_account_view_model.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  late ManageAccountViewModel _manageAccountViewModel;

  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<ManageAccountViewModel>(
        onModelReady: (model) {
          _manageAccountViewModel = model;
          _manageAccountViewModel.fetchAccounts();
        },
        builder: (context, model, child) => _scaffold());
  }

  Widget _scaffold() {
    return Scaffold(
      backgroundColor: context.appHomeScreenBgColor,
      appBar: AppBar(title: Text("Accounts"), actions: _appBarActions()),
      body: _listView(),
      floatingActionButton: _fab(),
    );
  }

  List<Widget> _appBarActions() {
    List<Widget> list = [];
    if (!_isEditMode) {
      var editWidget = InkWell(
        onTap: () {
          AnalyticsHelper.logEvent(
              event: AnalyticsHelper.manageAccountEditModeClicked);
          setState(() {
            _isEditMode = true;
          });
        },
        child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Icon(Icons.edit_outlined)),
      );
      list.add(editWidget);
    } else {
      var doneWidget = InkWell(
        onTap: () {
          AnalyticsHelper.logEvent(
              event: AnalyticsHelper.manageAccountDoneEditModeClicked);
          setState(() {
            _isEditMode = false;
          });
        },
        child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Icon(Icons.done)),
      );
      list.add(doneWidget);
    }
    return list;
  }

  Widget _listView() {
    return Container(
      child: ListView.builder(
          padding:
              const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
          itemCount: _manageAccountViewModel.accounts.length,
          itemBuilder: (context, index) {
            return _row(_manageAccountViewModel.accounts[index]);
          }),
    );
  }

  Widget _row(Account account) {
    return InkWell(
      onTap: _isEditMode
          ? null
          : () => _openAddEditAccountScreen(account: account),
      child: Container(
        padding: EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Column(
          children: [
            Row(
              children: [
                Text(account.emoji,
                    style: CustomTextStyle.emojiStyle(
                        context: context, fontSize: 24)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(account.isActive ? "Show" : "Hidden",
                          style: TextStyle(
                              fontSize: 12,
                              color: context.appPrimaryColor.withOpacity(0.6))),
                    ],
                  ),
                ),
                Spacer(),
                const SizedBox(width: 12),
                if (_isEditMode)
                  _switchWidget(account, (value) {
                    AnalyticsHelper.logEvent(
                        event: AnalyticsHelper
                            .manageAccountVisibilityToggleClicked,
                        params: {"value": value});
                    setState(() {
                      account.isActive = value;
                    });
                  })
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 0, thickness: 0)
          ],
        ),
      ),
    );
  }

  Widget _switchWidget(Account account, ValueChanged<bool> callback) {
    // var widget = Container(
    //   height: 34.0,
    //   width: 42.0,
    //   child: FittedBox(
    //       fit: BoxFit.contain,
    //       child: CupertinoSwitch(
    //           value: category.isActive,
    //           activeColor: context.appPrimaryColor.withOpacity(0.8),
    //           onChanged: callback)),
    // );

    var widget = Switch(
        value: account.isActive,
        activeColor: context.appPrimaryColor.withOpacity(0.8),
        onChanged: callback);

    return widget;
  }

  void _openAddEditAccountScreen({Account? account}) {
    _addAnalytics(isAdd: account == null);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditAccountScreen(
              account: account,
              addOrEditPerformed: () => _manageAccountViewModel.fetchAccounts(),
            )));
  }

  void _addAnalytics({required bool isAdd}) {
    String eventName = AnalyticsHelper.manageAccountRowClicked;
    if (isAdd) {
      eventName = AnalyticsHelper.manageAccountAddClicked;
    }
    AnalyticsHelper.logEvent(event: eventName);
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () => _openAddEditAccountScreen(),
      tooltip: 'Add Account',
      backgroundColor: context.appSecondaryColor,
      child: Icon(
        Icons.add,
        size: 32,
        color: context.appPrimaryColor,
      ),
    );
  }
}
