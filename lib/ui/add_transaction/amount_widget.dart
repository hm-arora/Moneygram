import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/utils/currency_helper.dart';

class AmountWidget extends StatelessWidget {
  final String? amount;
  const AmountWidget({
    required this.amount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: renderAmount(context)),
        ],
      ),
    );
  }

  Widget renderAmount(BuildContext context) {
    TextStyle style = const TextStyle(
        color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 48);
    String display = "0";
    if (amount != null && amount!.isNotEmpty) {
      // NumberFormat f = NumberFormat('#,###');
      display = amount!;
      // display = f.format(int.parse(amount));
      style = style.copyWith(
        color: context.appPrimaryColor,
      );
    }
    Color textColor = (amount == null || amount!.isEmpty)
        ? Colors.grey
        : context.appPrimaryColor;
    TextSpan textSpan = TextSpan(children: [
      TextSpan(
        text: CurrencyHelper.getCurrencySymbol(),
        style: TextStyle(color: textColor, fontSize: 48),
      ),
      TextSpan(text: display, style: style),
    ]);
    return AutoSizeText.rich(textSpan,
        textAlign: TextAlign.center, maxLines: 1, minFontSize: 8, style: style);
  }
}
