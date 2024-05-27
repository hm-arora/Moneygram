import 'package:intl/intl.dart';
import 'package:moneygram/utils/time_extension.dart';

class Timeline {
  final DateTime startTime;
  final DateTime endTime;

  String get decoratedStartTime => DateFormat('dd MMM').format(startTime);
  String get decoratedEndTime => DateFormat('dd MMM').format(endTime);

  String toString() {
    return "${decoratedStartTime} - ${decoratedEndTime}";
  }

  Timeline({required this.startTime, required this.endTime});

  factory Timeline.currentWeek() {
    DateTime startTime = findFirstDateOfTheWeek(DateTime.now());
    DateTime endTime = findLastDateOfTheWeek(DateTime.now());
    return Timeline(startTime: startTime, endTime: endTime);
  }

  factory Timeline.currentMonth() {
    DateTime startTime = findFirstDateOfTheMonth(DateTime.now());
    DateTime endTime = findLastDateOfTheMonth(DateTime.now());
    return Timeline(startTime: startTime, endTime: endTime);
  }

  Timeline previousWeek() {
    var previousDateTime = this.startTime.subtract(Duration(days: 7));
    DateTime startTime = findFirstDateOfTheWeek(previousDateTime);
    DateTime endTime = findLastDateOfTheWeek(previousDateTime);
    return Timeline(startTime: startTime, endTime: endTime);
  }

  Timeline nextWeek() {
    var previousDateTime = this.startTime.add(Duration(days: 7));
    DateTime startTime = findFirstDateOfTheWeek(previousDateTime);
    DateTime endTime = findLastDateOfTheWeek(previousDateTime);
    return Timeline(startTime: startTime, endTime: endTime);
  }

  Timeline previousMonth() {
    var previousDateTime =
        DateTime(this.startTime.year, this.startTime.month - 1, 1);
    DateTime startTime = findFirstDateOfTheMonth(previousDateTime);
    DateTime endTime = findLastDateOfTheMonth(previousDateTime);
    return Timeline(startTime: startTime, endTime: endTime);
  }

  Timeline nextMonth() {
    var previousDateTime =
        DateTime(this.startTime.year, this.startTime.month + 1, 1);
    DateTime startTime = findFirstDateOfTheMonth(previousDateTime);
    DateTime endTime = findLastDateOfTheMonth(previousDateTime);
    return Timeline(startTime: startTime, endTime: endTime);
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    var updatedDateTime =
        dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return DateTime(updatedDateTime.year, updatedDateTime.month,
        updatedDateTime.day, 0, 0, 0);
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    var updatedDateTime =
        dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    return DateTime(updatedDateTime.year, updatedDateTime.month,
        updatedDateTime.day, 23, 59, 59);
  }

  static DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  static DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0, 23, 59, 59);
  }

  bool isDateInRange(DateTime dateTime) {
    return startTime.isLessThanEqualTo(dateTime) &&
        endTime.isGreaterThanEqualTo(dateTime);
  }
}
