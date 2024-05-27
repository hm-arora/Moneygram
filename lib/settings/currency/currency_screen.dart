import 'package:flutter/material.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/settings/currency/currency_utils.dart';
import 'package:moneygram/ui/base_screen.dart';
import 'package:moneygram/utils/analytics_helper.dart';
import 'package:moneygram/utils/currency_helper.dart';
import 'package:moneygram/viewmodels/currency_viewmodel.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late CurrencyViewModel _currencyViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CurrencyViewModel>(
        onModelReady: (model) {
          _currencyViewModel = model;
          _currencyViewModel.setLocales();
        },
        builder: (context, model, child) => _scaffold());
  }

  Widget _scaffold() {
    return Scaffold(
        backgroundColor: context.appHomeScreenBgColor,
        appBar: AppBar(
          title: Text("Currency"),
        ),
        body: _listView());
  }

  Widget _listView() {
    return Container(
      color: context.appHomeScreenBgColor,
      child: ListView.builder(
          padding:
              const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
          itemCount: _currencyViewModel.countries.length,
          itemBuilder: (context, index) {
            return _row(index);
          }),
    );
  }

  Widget _row(int index) {
    CountryLocale countryLocale = _currencyViewModel.countries[index];
    bool isSelected =
        CurrencyHelper.getLocaleName() == countryLocale.locale.languageCode;
    return InkWell(
      onTap: () {
        AnalyticsHelper.logEvent(
            event: AnalyticsHelper.currencySelectorRowClicked,
            params: {"locale": countryLocale.toString()});
        _currencyViewModel.selectedCountryLocale(countryLocale);
      },
      child: Container(
        padding: EdgeInsets.only(top: 12, left: 16, right: 16),
        color: isSelected ? context.appPrimaryColor.withOpacity(0.05) : null,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(countryLocale.name),
                    Text(CurrencyHelper.getCurrencyName(
                        locale: countryLocale.locale))
                  ],
                ),
                Spacer(),
                Text(CurrencyHelper.getCurrencySymbol(
                    locale: countryLocale.locale)),
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 0, thickness: 0)
          ],
        ),
      ),
    );
  }
}
