import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneygram/utils/enum/filter_budget.dart';

extension DateUtils on DateTime {
  bool isGreaterThanEqualTo(DateTime dateTime) {
    return this.isAtSameMomentAs(dateTime) || this.isAfter(dateTime);
  }

  bool isLessThanEqualTo(DateTime dateTime) {
    return this.isAtSameMomentAs(dateTime) || this.isBefore(dateTime);
  }

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  int get daysDifference => daysElapsedSince(this, DateTime.now());

  int get ordinalDate {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[month - 1] + day + (isLeapYear && month > 2 ? 1 : 0);
  }

  /// True if this date is on a leap year.
  bool get isLeapYear {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  int get weekOfYear {
    final woy = ((ordinalDate - weekday + 10) ~/ 7);
    if (woy == 0) {
      return DateTime(year - 1, 12, 28).weekOfYear;
    }
    if (woy == 53 &&
        DateTime(year, 1, 1).weekday != DateTime.thursday &&
        DateTime(year, 12, 31).weekday != DateTime.thursday) {
      return 1;
    }
    return woy;
  }

  String formatted(FilterBudget filterBudget) {
    switch (filterBudget) {
      case FilterBudget.daily:
        return DateFormat('dd EEEE MMM').format(this);
      case FilterBudget.weekly:
        return "$weekOfYear Week of ${DateFormat('yyyy').format(this)}";
      case FilterBudget.monthly:
        return DateFormat('MMMM yyyy').format(this);
      case FilterBudget.yearly:
        return DateFormat('yyyy').format(this);
      case FilterBudget.all:
        return 'All';
    }
  }

  DateTime formattedDateTime(FilterBudget filterBudget) {
    switch (filterBudget) {
      case FilterBudget.monthly:
        return DateFormat('MMMM yyyy')
            .parse(DateFormat('MMMM yyyy').format(this));
      case FilterBudget.yearly:
        return DateFormat('yyyy').parse(DateFormat('yyyy').format(this));
      default:
        var formattedDate = DateFormat('dd MMM yyyy').format(this);
        return DateFormat('dd MMM yyyy')
            .parse(formattedDate);
    }
  }

  bool isAfterBeforeTime(DateTimeRange range) {
    return (isAfter(range.start) || isAtSameMomentAs(range.start)) &&
        (isAtSameMomentAs(range.end) || isBefore(range.end));
  }

  String get decoratedDay {
    return DateFormat('dd').format(this);
  }

  String get decoratedWeek {
    return DateFormat('EEEE').format(this);
  }

  String get decoratedMonthAndYear {
    return DateFormat('MMMM yyyy').format(this);
  }

  String get decoratedDate {
    if (isToday) {
      return "Today";
    }
    return DateFormat('dd MMM').format(this);
  }
}

int daysElapsedSince(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return to.difference(from).inDays;
}
