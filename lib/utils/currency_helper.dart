import 'dart:io';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:moneygram/di/service_locator.dart';
import 'package:moneygram/settings/settings_service.dart';
import 'package:moneygram/transactions/models/transaction.dart';

class CurrencyHelper {
  static String? currentAppLevelLocale;

  static String getLocaleName() {
    String? locale = currentAppLevelLocale;
    if (locale != null) {
      return locale;
    }
    currentAppLevelLocale = Platform.localeName;
    return currentAppLevelLocale!;
  }

  static Future<void> setSettingLevelLocale() async {
    SettingsService settingsService = locator.get();
    var settingLevelLocale = await settingsService.language();
    currentAppLevelLocale = settingLevelLocale.languageCode;
  }

  static String getCurrencySymbol({Locale? locale}) {
    String currentLocale;
    if (locale != null) {
      currentLocale = locale.languageCode;
    } else {
      currentLocale = getLocaleName();
    }
    var format = NumberFormat.simpleCurrency(locale: currentLocale);
    return format.currencySymbol;
  }

  static String getCurrencyName({Locale? locale}) {
    String currentLocale;
    if (locale != null) {
      currentLocale = locale.languageCode;
    } else {
      currentLocale = getLocaleName();
    }
    return NumberFormat.compactSimpleCurrency(locale: currentLocale)
            .currencyName ??
        '';
  }

  static String formattedCurrency(double currency, {int? decimalDigits = 2}) {
    var currentLocale = getLocaleName();
    return NumberFormat.simpleCurrency(
      locale: currentLocale.toString(),
      decimalDigits: decimalDigits,
    ).format(currency);
  }

  static String totalExpenseWithSymbol(List<Transaction> transactions) {
    final total = transactions
        .map((e) => e.amount)
        .fold<double>(0, (previousValue, element) => previousValue + element);
    return formattedCurrency(total);
  }
}
