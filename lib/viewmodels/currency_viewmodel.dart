import 'package:moneygram/settings/currency/currency_utils.dart';
import 'package:moneygram/settings/settings_service.dart';
import 'package:moneygram/utils/currency_helper.dart';
import 'package:moneygram/viewmodels/base_view_model.dart';

class CurrencyViewModel extends BaseViewModel {
  CurrencyViewModel({required this.settingsService});

  final SettingsService settingsService;

  List<CountryLocale> countries = [];

  void setLocales() {
    countries = getLocales();
    print(countries);
  }

  void selectedCountryLocale(CountryLocale countryLocale) {
    CurrencyHelper.currentAppLevelLocale = countryLocale.locale.languageCode;
    settingsService.setLanguage(countryLocale.locale);
    notifyListeners();
  }
}
