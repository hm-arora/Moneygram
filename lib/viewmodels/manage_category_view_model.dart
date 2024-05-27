import 'package:moneygram/category/model/category.dart';
import 'package:moneygram/category/repository/category_repository.dart';
import 'package:moneygram/utils/enum/transaction_type.dart';
import 'package:moneygram/viewmodels/base_view_model.dart';

class ManageCategoryViewModel extends BaseViewModel {
  ManageCategoryViewModel({required this.categoryRepository});

  final CategoryRepository categoryRepository;
  List<Category> expenseCategories = [];
  List<Category> incomeCategories = [];
  List<Category> filteredCategories = [];
  TransactionType selectedTransactionType = TransactionType.expense;

  void initState() async {
    await fetchCategories();
    setTransactionType(selectedTransactionType);
  }

  Future<void> fetchCategories() async {
    expenseCategories = [];
    incomeCategories = [];
    var categories =
        await categoryRepository.categories(includingInActive: true);
    for (var category in categories) {
      if (category.transactionType == TransactionType.expense) {
        expenseCategories.add(category);
      } else {
        incomeCategories.add(category);
      }
    }
  }

  void setTransactionType(TransactionType type) {
    selectedTransactionType = type;
    if (type == TransactionType.expense) {
      filteredCategories = expenseCategories;
    } else {
      filteredCategories = incomeCategories;
    }
    notifyListeners();
  }

  void setStatus({required Category category, required bool status}) {
    category.isActive = status;
    category.save();
    notifyListeners();
  }
}
