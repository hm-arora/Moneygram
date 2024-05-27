import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class CustomTextStyle {
  static TextStyle emojiStyle(
      {required BuildContext context,
      double fontSize = 14,
      Color? color,
      FontWeight fontWeight = FontWeight.w400}) {
    color = color ?? context.appPrimaryColor;
    // return TextStyle(fontSize: fontSize, color: color);
    return GoogleFonts.notoEmoji(
        fontSize: fontSize, color: color, fontWeight: fontWeight);
  }
}
