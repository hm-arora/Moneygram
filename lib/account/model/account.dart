import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 2)
class Account extends HiveObject {
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
  bool isCustomAccount;

  Account(
      {required this.emoji,
      required this.name,
      this.id,
      this.isSync = false,
      this.isActive = true,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isCustomAccount})
      : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now(),
        this.isCustomAccount = isCustomAccount ?? true;

  Map<String, dynamic> toJson() => {
        'emoji': emoji,
        'name': name,
        'id': id,
        'isSync': isSync,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isActive': isActive
      };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
      name: json["name"],
      emoji: json["emoji"],
      isSync: json['isSync'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'])
    ..id = json["id"];

  String uniqueCode() {
    return "${id}#${createdAt.toIso8601String()}";
  }
}
