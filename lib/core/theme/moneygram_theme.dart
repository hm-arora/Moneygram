import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneygram/di/service_locator.dart';
import 'package:moneygram/settings/settings_service.dart';
import 'package:moneygram/utils/custom_colors.dart';
import 'package:moneygram/utils/enum/theme_mode.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get primaryColor => this.brightness == Brightness.light
      ? CustomColors.lightPrimaryColor
      : CustomColors.darkPrimaryColor;

  Color get primaryColor26 => primary.withOpacity(0.26);

  Color get secondaryColor => this.brightness == Brightness.light
      ? CustomColors.lightSecondaryColor
      : CustomColors.darkSecondaryColor;

  Color get disableTextColorBtn => this.brightness == Brightness.light
      ? CustomColors.lightDisableTextColorBtn
      : CustomColors.darkDisableTextColorBtn;

  Color get disableBgColorBtn => this.brightness == Brightness.light
      ? CustomColors.lightDisableBgColorBtn
      : CustomColors.darkDisableBgColorBtn;

  Color get bgColor => this.brightness == Brightness.light
      ? CustomColors.lightBgColor
      : CustomColors.darkBgColor;

  Color get homeScreenBgColor => this.brightness == Brightness.light
      ? CustomColors.lightHomeScreenBgColor
      : CustomColors.darkHomeScreenBgColor;

  Color get toggleBgColor => this.brightness == Brightness.light
      ? CustomColors.lightToggleBgColor
      : CustomColors.darkToggleBgColor;
}

extension ColorText on BuildContext {
  Color get appPrimaryColor {
    return Theme.of(this).colorScheme.primaryColor;
  }

  Color get appPrimaryColor26 {
    return Theme.of(this).colorScheme.primaryColor26;
  }

  Color get appSecondaryColor {
    return Theme.of(this).colorScheme.secondaryColor;
  }

  Color get appDisableTextColorBtn {
    return Theme.of(this).colorScheme.disableTextColorBtn;
  }

  Color get appDisableBgColorBtn {
    return Theme.of(this).colorScheme.disableBgColorBtn;
  }

  Color get appBgColor {
    return Theme.of(this).colorScheme.bgColor;
  }

  Color get appHomeScreenBgColor {
    return Theme.of(this).colorScheme.homeScreenBgColor;
  }

  Color get appToggleBgColor {
    return Theme.of(this).colorScheme.toggleBgColor;
  }
}

ElevatedButtonThemeData elevatedButtonTheme(
  BuildContext context,
  ColorScheme colorScheme,
) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      textStyle: GoogleFonts.outfit(
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
      ),
    ),
  );
}

InputDecorationTheme get inputDecorationTheme {
  return InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    filled: true,
  );
}

NavigationBarThemeData navigationBarThemeData(ColorScheme colorScheme) {
  return NavigationBarThemeData(
    backgroundColor: colorScheme.surface,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    labelTextStyle: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return GoogleFonts.outfit().copyWith(fontWeight: FontWeight.bold);
      } else {
        return GoogleFonts.outfit();
      }
    }),
  );
}

FloatingActionButtonThemeData floatingActionButton(ColorScheme colorScheme) {
  return FloatingActionButtonThemeData(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
  );
}

AppBarTheme appBarThemeLight(ColorScheme colorScheme) {
  return AppBarTheme(
    elevation: 0,
    backgroundColor: colorScheme.secondaryColor,
    foregroundColor: colorScheme.primaryColor,
    surfaceTintColor: CustomColors.lightSecondaryColor,
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ),
  );
}

AppBarTheme appBarThemeDark(ColorScheme colorScheme) {
  return AppBarTheme(
    elevation: 0,
    backgroundColor: colorScheme.secondaryColor,
    foregroundColor: colorScheme.primaryColor,
    surfaceTintColor: CustomColors.darkSecondaryColor,
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ),
  );
}

DialogTheme dialogTheme() {
  return DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
}

class ThemeModeHelper {
  static ThemeMode currentTheme() {
    SettingsService settingsService = locator.get();
    return settingsService.themeMode();
  }

  static String currentThemeStr() {
    return currentTheme().themeName;
  }

  static void setTheme(ThemeMode mode) {
    SettingsService settingsService = locator.get();
    settingsService.setThemeMode(mode);
  }

  static int index(ThemeMode mode) {
    if (mode == ThemeMode.light) {
      return 0;
    }
    if (mode == ThemeMode.dark) {
      return 1;
    }
    return 2;
  }

  static ThemeMode themeMode(int index) {
    if (index == 0) {
      return ThemeMode.light;
    }
    if (index == 1) {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }
}

// CustomColors lightCustomColor = CustomColors(
//   red: Colors.red.shade400,
//   green: Colors.green.shade400,
// );
// CustomColors darkCustomColor = CustomColors(
//   red: Colors.red.shade400,
//   green: Colors.green.shade400,
// );
