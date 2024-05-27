import 'package:hive/hive.dart';
import 'package:moneygram/account/data_source/account_local_data_source.dart';
import 'package:moneygram/account/model/account.dart';
import 'package:moneygram/utils/enum/box_types.dart';
import 'package:collection/collection.dart';

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  late final accountBox = Hive.box<Account>(BoxType.accounts.stringValue);

  @override
  Future<List<Account>> accounts() async {
    final accounts =
        accountBox.values.where((element) => element.isActive).toList();
    return accounts;
  }

  @override
  Future<void> addOrUpdateAccount(Account account) async {
    final int id = await accountBox.add(account);
    account.id = id;
    await account.save();
  }

  @override
  Future<void> deleteAccount(int key) {
    // final transactionBox = Hive.box<Transaction>(BoxType.transactions.stringValue);
    // final keys = transactionBox.values
    //     .where((element) => element.accountId == key)
    //     .map((e) => e.key);
    // await transactionBox.deleteAll(keys);
    // TODO: need to handle the case where deleting an account will delete transaction as well
    return accountBox.delete(key);
  }

  @override
  Account? fetchAccount(int accountId) {
    return accountBox.values.firstWhereOrNull((element) {
      return element.isActive && element.id == accountId;
    });
  }

  @override
  Future<Account?> fetchAccountFromId(int accountId) async {
    return accountBox.get(accountId);
  }

  @override
  Box<Account> getBox() {
    return accountBox;
  }
}
