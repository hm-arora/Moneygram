import 'package:hive/hive.dart';

part 'transaction_type.g.dart';

@HiveType(typeId: 4)
enum TransactionType {
  @HiveField(0)
  expense,
  @HiveField(1)
  income
}

extension TransactionTypeMapping on TransactionType {
  String get nameString {
    switch (this) {
      case TransactionType.expense:
        return 'expense';
      case TransactionType.income:
        return 'income';
      /*  case TransactionType.transfer:
        return 'transfer'; */
    }
  }
}

extension TransactionMap on String {
  TransactionType get type {
    switch (this) {
      case 'expense':
        return TransactionType.expense;
      case 'income':
        return TransactionType.income;
      /* case 'transfer':
        return TransactionType.transfer; */
    }
    return TransactionType.expense;
  }
}
