import 'package:moneygram/account/data_source/account_local_data_source.dart';
import 'package:moneygram/account/model/account.dart';
import 'package:moneygram/account/repository/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  AccountRepositoryImpl({required this.dataSource});

  final AccountLocalDataSource dataSource;

  @override
  Future<List<Account>> accounts({bool isSort = true}) async {
    final accounts = await dataSource.accounts();
    if (isSort) {
      accounts.sort((a, b) => a.name.compareTo(b.name));
    }
    return accounts;
  }

  @override
  Future<void> addAccount({required Account account}) async {
    await dataSource.addOrUpdateAccount(account);
  }

  @override
  Future<void> deleteAccount(int key) {
    return dataSource.deleteAccount(key);
  }

  @override
  Future<Account?> fetchAccountFromId(int accountId) async {
    return await dataSource.fetchAccountFromId(accountId);
  }

  @override
  Future<void> updateAccount(Account account) async {
    await dataSource.addOrUpdateAccount(account);
  }
}
