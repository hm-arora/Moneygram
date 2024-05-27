enum BoxType { accounts, category, settings, transactions }

extension BoxTypeMapping on BoxType {
  String get stringValue {
    switch (this) {
      case BoxType.accounts:
        return 'accounts';
      case BoxType.category:
        return 'category';
      case BoxType.transactions:
        return 'transactions';
      case BoxType.settings:
        return 'settings';
    }
  }
}
