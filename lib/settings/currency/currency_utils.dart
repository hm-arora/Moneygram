import 'package:flutter/material.dart';

List<CountryLocale> getLocales() => [
      CountryLocale("US Dollar", const Locale('en')),
      CountryLocale("Indian Rupee", const Locale('hi')),
      CountryLocale("Malaysia Ringgit", const Locale('ms')),
      CountryLocale("Ukrainian Hryvnia", const Locale('uk')),
      CountryLocale("Polish Złoty", const Locale('pl')),
      CountryLocale("Austria Euro", const Locale('de')),
      CountryLocale("Bangladesh Taka", const Locale('bn')),
      CountryLocale("Turkish lira", const Locale('tr')),
      CountryLocale("Mexican Peso", const Locale('es-mx')),
      CountryLocale("Philippine Peso", const Locale('fil')),
      CountryLocale("Indonesian Rupiah", const Locale('id')),
      CountryLocale("Vietnamese Dong", const Locale('vi')),
      CountryLocale("Lebanese Pound", const Locale('ar-lb')),
      CountryLocale("Taiwan Dollar", const Locale('zh-tw')),
      CountryLocale("Sri Lanka Rupee", const Locale('si')),
      CountryLocale("Pakistan Rupee", const Locale('ur')),
      CountryLocale("Swiss Franc", const Locale('fr_CH')),
      CountryLocale("Egyptian Pound", const Locale('ar_EG')),
      CountryLocale("Brazilian Real", const Locale('pt')),
      CountryLocale("Russian Ruble", const Locale('ru')),
      CountryLocale("Chinese Yuan", const Locale('zh')),
    ];

class CountryLocale {
  final String name;
  final Locale locale;

  CountryLocale(this.name, this.locale);

  @override
  String toString() {
    return "$name, $locale";
  }
}
