import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/utils/analytics_helper.dart';
import 'package:moneygram/utils/broadcast/broadcast_channels.dart';
import 'package:moneygram/utils/broadcast/broadcast_receiver.dart';
import 'package:moneygram/utils/enum/theme_mode.dart';

class ThemeSelectorScreen extends StatefulWidget {
  const ThemeSelectorScreen({Key? key}) : super(key: key);

  @override
  State<ThemeSelectorScreen> createState() => _ThemeSelectorScreenState();
}

class _ThemeSelectorScreenState extends State<ThemeSelectorScreen> {
  ThemeMode _selectedTheme = ThemeModeHelper.currentTheme();

  @override
  Widget build(BuildContext context) {
    return Container(color: context.appHomeScreenBgColor, child: _content());
  }

  Widget _content() {
    return SafeArea(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [_header(), const SizedBox(height: 12), _body()]),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._radioButtons(),
          ]),
    );
  }

  Widget _header() {
    return Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
        color: context.appSecondaryColor,
        child: IntrinsicHeight(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Theme",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, thickness: 0)
          ],
        )));
  }

  List<Widget> _radioButtons() {
    return [
      _radioButton(ThemeMode.light),
      SizedBox(height: 8),
      _radioButton(ThemeMode.dark),
      SizedBox(height: 8),
      _radioButton(ThemeMode.system),
      SizedBox(height: 8),
    ];
  }

  Widget _radioButton(ThemeMode mode) {
    Widget radio = SizedBox(
      height: 16,
      width: 16,
      child: Radio(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: mode,
          groupValue: _selectedTheme,
          activeColor: context.appPrimaryColor,
          onChanged: (value) {
            _selectedValueCallback(mode);
          }),
    );
    return InkWell(
      onTap: () {
        _selectedValueCallback(mode);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            radio,
            SizedBox(width: 12),
            Text(
              mode.themeName,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  void _selectedValueCallback(ThemeMode mode) {
    AnalyticsHelper.logEvent(
        event: AnalyticsHelper.themeSelectorRowClicked,
        params: {"theme_mode": mode.themeName});
    setState(() {
      _selectedTheme = mode;
      ThemeModeHelper.setTheme(mode);
      BroadcastReceiver.broadcastController.add(BroadcastChannels.refreshTheme);
    });
  }
}
