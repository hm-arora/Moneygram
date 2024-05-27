import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:moneygram/category/category_hive_helper.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/di/service_locator.dart';
import 'package:moneygram/feature_flags/feature_flag_helper.dart';
import 'package:moneygram/ui/bottom_navigation_state.dart';
import 'package:moneygram/utils/broadcast/broadcast_channels.dart';
import 'package:moneygram/utils/broadcast/broadcast_receiver.dart';
import 'package:moneygram/utils/currency_helper.dart';
import 'package:moneygram/utils/validation_utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
late Mixpanel mixPanel;
final ValueNotifier<bool> darkThemeListenable = ValueNotifier(false);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await setupLocator();
  // await initSentry();
  initMixpanel();
  await CurrencyHelper.setSettingLevelLocale();
  FeatureFlagHelper.instance.init();
  CategoryHiveHelper().addCategoriesInHive();
  runApp(const MyApp());
}

Future<void> initSentry() async {
  await SentryFlutter.init((options) {
    options.dsn =
        'https://1fdd11a606e64298807d4f68ace0b8ff@o4504464326066176.ingest.sentry.io/4504464334258176';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
  });
}

Future<void> initMixpanel() async {
  String mixPanelToken = "5dd1a2c11d598f709a4ec52fde4e92d6";
  mixPanel = await Mixpanel.init(mixPanelToken);
  var distinctId = await mixPanel.getDistinctId();
  mixPanel.identify(distinctId);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    setBroadcastListener();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void setBroadcastListener() {
    _streamSubscription =
        BroadcastReceiver.broadcastController.stream.listen((event) {
      if (ValidationUtils.isValidString(event) &&
          event == BroadcastChannels.refreshTheme) {
        darkThemeListenable.value = !darkThemeListenable.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: darkThemeListenable,
        builder: (context, value, _) {
          ThemeMode themeMode = ThemeModeHelper.currentTheme();
          print(themeMode);
          ColorScheme lightColorScheme = ColorScheme.fromSeed(
            seedColor: context.appPrimaryColor,
            primary: context.appSecondaryColor,
          );
          ColorScheme darkColorScheme = ColorScheme.fromSeed(
            seedColor: context.appPrimaryColor,
            primary: context.appSecondaryColor,
            onSurfaceVariant: context.appSecondaryColor,
            brightness: Brightness.dark,
          );
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.from(
              colorScheme: lightColorScheme,
            ).copyWith(
              colorScheme: lightColorScheme,
              dialogTheme: dialogTheme(),
              appBarTheme: appBarThemeLight(lightColorScheme),
              useMaterial3: true,
              scaffoldBackgroundColor: lightColorScheme.background,
              dialogBackgroundColor: lightColorScheme.background,
              navigationBarTheme: navigationBarThemeData(lightColorScheme),
              applyElevationOverlayColor: true,
              inputDecorationTheme: inputDecorationTheme,
              elevatedButtonTheme: elevatedButtonTheme(
                context,
                lightColorScheme,
              ),
            ),
            darkTheme: ThemeData.from(
              colorScheme: darkColorScheme,
            ).copyWith(
              colorScheme: darkColorScheme,
              dialogTheme: dialogTheme(),
              appBarTheme: appBarThemeDark(darkColorScheme),
              useMaterial3: true,
              scaffoldBackgroundColor: darkColorScheme.background,
              dialogBackgroundColor: darkColorScheme.background,
              navigationBarTheme: navigationBarThemeData(darkColorScheme),
              applyElevationOverlayColor: true,
              inputDecorationTheme: inputDecorationTheme,
              elevatedButtonTheme: elevatedButtonTheme(
                context,
                darkColorScheme,
              ),
            ),
            themeMode: themeMode,
            navigatorKey: navigatorKey,
            title: 'Money',
            home: BottomNavigationState(),
          );
        });
  }
}
