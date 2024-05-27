class ValidationUtils {
  static bool isValidString(String? string) {
    return string != null && string.trim() != '';
  }

  static bool isValidList(List<dynamic>? list) {
    return list != null && list.length > 0;
  }

  static bool isValidDouble(double? value) {
    return value != null && value > 0 && value != double.infinity;
  }

  static bool isValidInteger(int? value) {
    return value != null && value > 0;
  }

  static bool isValidIntegerString(String? value) {
    if (isValidString(value)) {
      value = value!.trim();
      try {
        int.parse(value);
        return true;
      } catch (NumberFormatException) {
        return false;
      }
    }
    return false;
  }

  static bool isValidDoubleString(String? doubleValue) {
    if (isValidString(doubleValue)) {
      doubleValue = doubleValue!.trim();
      try {
        double.parse(doubleValue);
        return true;
      } catch (NumberFormatException) {
        return false;
      }
    }
    return false;
  }

  static bool isValidDoubleValue(String? doubleValue) {
    if (isValidDoubleString(doubleValue)) {
      doubleValue = doubleValue!.trim();
      try {
        double val = double.parse(doubleValue);
        return isValidDouble(val);
      } catch (NumberFormatException) {
        return false;
      }
    }
    return false;
  }

  static bool isValidEmail(String email) {
    return RegExp(r"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        .hasMatch(email);
  }
}
