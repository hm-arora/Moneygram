import 'package:moneygram/account/model/account.dart';
import 'package:moneygram/account/repository/account_repository.dart';
import 'package:moneygram/category/model/category.dart';
import 'package:moneygram/category/repository/category_repository.dart';
import 'package:moneygram/di/service_locator.dart';
import 'package:moneygram/utils/utils.dart';

class CategoryHiveHelper {
  final CategoryRepository _categoryRepository = locator<CategoryRepository>();
  final AccountRepository _accountRepository = locator<AccountRepository>();

  void addCategoriesInHive() async {
    var categories = await _categoryRepository.categories();
    if (categories.isEmpty) {
      List<Category> list = Utils.getExpensesCategory();
      for (var category in list) {
        _categoryRepository.addCategory(category: category);
      }
    }
    List<Account> accountList = Utils.getAccounts();
    var accounts = await _accountRepository.accounts();
    if (accounts.isNotEmpty) {
      return;
    }
    for (var account in accountList) {
      _accountRepository.addAccount(account: account);
    }
  }

  Future<List<Category>> getCategories() async {
    return _categoryRepository.categories();
  }

  Future<List<Account>> getAccounts() async {
    return _accountRepository.accounts();
  }
}
