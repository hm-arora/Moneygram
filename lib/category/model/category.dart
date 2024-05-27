import 'package:hive/hive.dart';
import 'package:moneygram/utils/enum/transaction_type.dart';

part 'category.g.dart';

@HiveType(typeId: 3)
class Category extends HiveObject {
  @HiveField(0)
  String emoji;

  @HiveField(1)
  String name;

  @HiveField(2)
  int? id;

  @HiveField(3, defaultValue: false)
  bool isSync;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  bool isActive;

  @HiveField(7)
  TransactionType transactionType;

  @HiveField(8)
  bool isCustomCategory;

  Category(
      {required this.emoji,
      required this.name,
      this.isSync = false,
      this.isActive = true,
      this.id,
      DateTime? createdAt,
      DateTime? updatedAt,
      TransactionType? transactionType,
      bool? isCustomCategory})
      : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now(),
        this.transactionType = transactionType ?? TransactionType.expense,
        this.isCustomCategory = isCustomCategory ?? true;

  Map<String, dynamic> toJson() => {
        'emoji': emoji,
        'name': name,
        'id': id,
        'isSync': isSync,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isActive': isActive,
        'transaction_type': transactionType.nameString
      };

  String uniqueCode() {
    return "${id}#${createdAt.toIso8601String()}";
  }

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        emoji: json["emoji"],
        isSync: json['isSync'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        isActive: json['isActive'],
        transactionType: (json['transaction_type'] as String).type,
      )..id = json["id"];
}
