import 'package:moneygram/account/model/account.dart';

abstract class AccountRepository {
  Future<List<Account>> accounts({bool isSort});
  Future<void> addAccount({
    required Account account,
  });
  Future<void> deleteAccount(int key);

  Future<void> updateAccount(Account account);

  Future<Account?> fetchAccountFromId(int accountId);
}
