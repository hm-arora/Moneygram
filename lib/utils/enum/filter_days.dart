enum FilterDays { today, yesterday, seven, thirty, all }

extension FilterDaysMapping on FilterDays {
  String get name {
    switch (this) {
      case FilterDays.today:
        return 'Today';
      case FilterDays.yesterday:
        return 'Yesterday';
      case FilterDays.seven:
        return 'Last 7 Days';
      case FilterDays.thirty:
        return 'Last 30 Days';
      case FilterDays.all:
        return 'All';
    }
  }

  int get days {
    switch (this) {
      case FilterDays.yesterday:
        return 1;
      case FilterDays.seven:
        return 7;
      case FilterDays.thirty:
        return 30;
      case FilterDays.today:
      case FilterDays.all:
        return 0;
    }
  }

  bool filterDate(int days) {
    switch (this) {
      case FilterDays.yesterday:
        return days == 1;
      case FilterDays.seven:
        return days > 1 && days <= 7;
      case FilterDays.thirty:
        return days > 1 && days <= 30;
      case FilterDays.today:
      case FilterDays.all:
        break;
    }
    return false;
  }
}
