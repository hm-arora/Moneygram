import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/utils/enum/box_types.dart';

const String themeModeKey = 'key_theme_mode';
const String appColorKey = 'key_app_color';
const String dynamicColorKey = 'key_dynamic_color';
const String pushNotificationKey = 'key_push_notification';
const String biometricKey = 'key_biometric';
const String userNameKey = 'user_name_key';
const String userLoginKey = 'user_login_key';
const String userImageKey = 'user_image_key';
const String userLanguageKey = 'user_language_key';
const String scheduleTime = 'schedule_time_key';
const String defaultCategory = 'default_category_key';
const String defaultAccount = 'default_account_key';

abstract class SettingsService {
  Future<void> setThemeMode(ThemeMode themeMode);
  ThemeMode themeMode();

  Future<void> setUpdateNotification(bool mode);
  Future<bool> notification();

  Future<void> setThemeColor(Color color);
  Future<Color> themeColor();

  Future<void> setDynamicColor(bool dynamicColor);
  Future<bool> dynamicColor();

  Future<String> userName();
  Future<void> setUserName(String name);

  Future<bool> isLoggedIn();
  Future<void> setLoggedIn(bool isLogin);

  Future<String> userImage();
  Future<void> setUserImage(String name);

  Future<Locale> language();
  Future<void> setLanguage(Locale locale);

  Future<void> setDefaultCategory(int categoryId);
  Future<int?> getDefaultCategory();

  Future<void> setDefaultAccount(int accountId);
  Future<int?> getDefaultAccount();
}

class SettingsServiceImpl implements SettingsService {
  late final box = Hive.box(BoxType.settings.stringValue);

  @override
  Future<String> userName() async {
    return box.get(userNameKey, defaultValue: 'Name');
  }

  @override
  Future<void> setUserName(String name) async {
    await box.put(userNameKey, name);
  }

  @override
  Future<bool> isLoggedIn() async {
    return box.get(userLoginKey, defaultValue: false) ?? false;
  }

  @override
  Future<void> setLoggedIn(bool isLogin) async {
    await box.put(userLoginKey, isLogin);
  }

  @override
  Future<String> userImage() async {
    return box.get(userImageKey, defaultValue: '');
  }

  @override
  Future<void> setUserImage(String name) async {
    await box.put(userImageKey, name);
  }

  @override
  Future<Locale> language() async {
    return Locale(box.get(userLanguageKey, defaultValue: 'en_IN'));
  }

  @override
  Future<void> setLanguage(Locale locale) async {
    await box.put(userLanguageKey, locale.languageCode);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await box.put(themeModeKey, ThemeModeHelper.index(themeMode));
  }

  @override
  ThemeMode themeMode() {
    // ThemeMode.values
    int index = box.get(themeModeKey, defaultValue: 0);
    return ThemeModeHelper.themeMode(index);
  }

  @override
  Future<void> setUpdateNotification(bool mode) async {
    await box.put(pushNotificationKey, mode);
  }

  @override
  Future<bool> notification() async {
    return box.get(pushNotificationKey, defaultValue: false);
  }

  @override
  Future<void> setThemeColor(Color color) async {
    await box.put(appColorKey, color.value);
  }

  @override
  Future<Color> themeColor() async {
    final colorInt = box.get(appColorKey, defaultValue: 0xFF795548);
    return Color(colorInt);
  }

  @override
  Future<void> setDynamicColor(bool dynamicColor) async {
    await box.put(dynamicColorKey, dynamicColor);
  }

  @override
  Future<bool> dynamicColor() async {
    return box.get(dynamicColorKey, defaultValue: false);
  }

  @override
  Future<void> setDefaultCategory(int categoryId) async {
    await box.put(defaultCategory, categoryId);
  }

  @override
  Future<int?> getDefaultCategory() async {
    return box.get(defaultCategory, defaultValue: null);
  }

  @override
  Future<void> setDefaultAccount(int accountId) async {
    await box.put(defaultAccount, accountId);
  }

  @override
  Future<int?> getDefaultAccount() async {
    return box.get(defaultAccount);
  }
}
