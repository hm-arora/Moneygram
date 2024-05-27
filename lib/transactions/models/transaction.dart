import 'package:hive/hive.dart';
import 'package:moneygram/utils/enum/transaction_type.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String? notes;

  @HiveField(1)
  double amount;

  @HiveField(2)
  TransactionType type;

  @HiveField(3)
  int accountId;

  @HiveField(4)
  int categoryId;

  @HiveField(5)
  DateTime time;

  @HiveField(6)
  int? id;

  @HiveField(7, defaultValue: false)
  bool isSync;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  @HiveField(10)
  bool isActive;

  Transaction(
      {this.notes,
      this.id,
      this.isSync = false,
      this.isActive = true,
      required this.amount,
      required this.time,
      required this.categoryId,
      required this.accountId,
      required this.type,
      DateTime? createdAt,
      DateTime? updatedAt})
      : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now();

  Transaction copyWith({required Transaction newTransaction}) {
    var obj = this;
    obj.notes = newTransaction.notes;
    obj.id = newTransaction.id;
    obj.isSync = newTransaction.isSync;
    obj.amount = newTransaction.amount;
    obj.time = newTransaction.time;
    obj.categoryId = newTransaction.categoryId;
    obj.accountId = newTransaction.accountId;
    obj.type = newTransaction.type;
    obj.createdAt = newTransaction.createdAt;
    obj.updatedAt = newTransaction.updatedAt;
    obj.isActive = newTransaction.isActive;
    return obj;
  }

  Map<String, dynamic> toJson() => {
        'notes': notes,
        'amount': amount,
        'time': time.toIso8601String(),
        'type': type.nameString,
        'accountId': accountId,
        'categoryId': categoryId,
        'id': id,
        'isSync': isSync,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isActive': isActive
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      notes: json['notes'],
      amount: json['amount'],
      time: DateTime.parse(json['time']),
      categoryId: json['categoryId'],
      accountId: json['accountId'],
      type: (json['type'] as String).type,
      isSync: (json['isSync'] ?? false),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'])
    ..id = json['id'];

  String uniqueCode() {
    return "${id}#${createdAt.toIso8601String()}";
  }
}
