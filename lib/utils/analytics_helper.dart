import 'package:moneygram/main.dart';

class AnalyticsHelper {
  static logEvent({required String event, Map<String, Object?>? params}) {
    mixPanel.track(event, properties: params);
  }

//AnalyticsEventsAndParamKeys
  static const String homePagePreviousTimelineClicked =
      "home_page_previous_timeline_clicked";
  static const String homePageNextTimelineClicked =
      "home_page_next_timeline_clicked";
  static const String homePageCardClicked = "home_page_card_clicked";
  static const String homePageAddTransactionClicked =
      "home_page_add_transaction_clicked";

  static const String bottomBarHomeClicked = "bottom_bar_home_clicked";
  static const String bottomBarInsightsClicked = "bottom_bar_insights_clicked";
  static const String bottomBarSettingsClicked = "bottom_bar_settings_clicked";

  static const String addTransactionSelectAccountClicked =
      "add_transaction_select_account_clicked";
  static const String addTransactionSelectCategoryClicked =
      "add_transaction_select_category_clicked";
  static const String addTransactionSelectDateClicked =
      "add_transaction_select_date_clicked";
  static const String addTransactionOutsideClicked =
      "add_transaction_outside_clicked";
  static const String addTransactionSaveClicked =
      "add_transaction_save_clicked";
  static const String updateTransactionMenuClicked =
      "update_transaction_menu_clicked";

  static const String settingsThemeClicked =
      "settings_theme_clicked";
  static const String settingsCurrencySelectorClicked =
      "settings_currency_selector_clicked";
  static const String settingsManageCategoryClicked =
      "settings_manage_category_clicked";
  static const String settingsManageAccountClicked =
      "settings_manage_account_clicked";
  static const String settingsGiveFeedbackClicked =
      "settings_give_feedback_clicked";
  static const String settingsRateAppClicked = "settings_rate_app_clicked";

  // theme
  static const String themeSelectorRowClicked = "theme_selector_row_clicked";

  // currency
  static const String currencySelectorRowClicked =
      "currency_selector_row_clicked";

  static const String manageCategoryEditModeClicked =
      "manage_category_edit_mode_clicked";
  static const String manageCategoryDoneEditClicked =
      "manage_category_done_edit_mode_clicked";
  static const String manageCategoryRowClicked = "manage_category_row_clicked";
  static const String manageCategoryAddClicked = "manage_category_add_clicked";
  static const String manageCategoryVisibilityToggleClicked =
      "manage_category_visibility_toggle_clicked";
  // switch b/w expense and income
  static const String manageCategoryToggleClicked =
      "manage_category_toggle_clicked";

  static const String manageAccountEditModeClicked =
      "manage_account_edit_mode_clicked";
  static const String manageAccountDoneEditModeClicked =
      "manage_account_done_edit_mode_clicked";
  static const String manageAccountRowClicked = "manage_account_row_clicked";
  static const String manageAccountAddClicked = "manage_account_add_clicked";
  static const String manageAccountVisibilityToggleClicked =
      "manage_account_visibility_toggle_clicked";

  static const String hardUpdateButtonClicked = "hard_update_button_clicked";
  static const String softUpdateButtonClicked = "soft_update_button_clicked";
  static const String softUpdateCrossButtonClicked =
      "soft_update_cross_button_clicked";

  static const String feedbackBottomSubmitButtonClicked =
      "feedback_bottom_submit_button_clicked";
  static const String feedbackAboveSubmitButtonClicked =
      "feedback_above_submit_button_clicked";
  static const String feedbackEmojiClicked = "feedback_emoji_clicked";
}
