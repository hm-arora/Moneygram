import 'package:moneygram/account/repository/account_repository.dart';
import 'package:moneygram/category/repository/category_repository.dart';
import 'package:moneygram/transactions/models/transaction.dart';
import 'package:moneygram/transactions/repository/transaction_repository.dart';
import 'package:moneygram/ui/home/models/timeline.dart';
import 'package:moneygram/ui/insights/insights_screen.dart';
import 'package:moneygram/viewmodels/base_view_model.dart';
import 'package:moneygram/utils/transaction_extension.dart';

class InsightsViewModel extends BaseViewModel {
  InsightsViewModel(
      {required this.transactionRepository,
      required this.accountRepository,
      required this.categoryRepository});
  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final CategoryRepository categoryRepository;

  Timeline timeline = Timeline.currentMonth();
  Map<DateTime, List<Transaction>> transactionList = Map();
  List<ChartSampleData> chartData = [];

  void init() {
    setTransactions();
  }

  void setTransactions() async {
    transactionList =
        await transactionRepository.getGroupedTransactions(true, timeline);
    int endDay = timeline.endTime.day;
    for (int i = 1; i <= endDay; i++) {
      var dateTime =
          DateTime(timeline.startTime.year, timeline.startTime.month, i);
      chartData
          .add(ChartSampleData(x: dateTime, y: transactionList[dateTime]?.totalExpense ?? 0));
    }
    notifyListeners();
  }

  void previousDate() {
    timeline = timeline.previousMonth();
    setTransactions();
  }

  void nextDate() {
    timeline = timeline.nextMonth();
    setTransactions();
  }
}
