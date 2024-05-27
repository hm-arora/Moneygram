import 'package:hive_flutter/adapters.dart';
import 'package:moneygram/account/model/account.dart';

abstract class AccountLocalDataSource {
  Future<void> addOrUpdateAccount(Account account);
  Future<void> deleteAccount(int key);
  Future<List<Account>> accounts();
  Box<Account> getBox();
  Account? fetchAccount(int accountId);
  Future<Account?> fetchAccountFromId(int accountId);
}
