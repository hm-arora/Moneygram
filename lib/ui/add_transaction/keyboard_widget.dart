import 'package:flutter/material.dart';
import 'package:moneygram/ui/keyboard/keyboard_key.dart';
import 'package:moneygram/utils/keyboard_helper.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class KeyboardWidget extends StatelessWidget {
  final Function() onBackPress;
  final Function(String value) onKeyPress;
  const KeyboardWidget(
      {Key? key, required this.onBackPress, required this.onKeyPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: renderKeyboard(context)),
    );
  }

  renderKeyboard(BuildContext context) {
    return KeyboardHelper.getKeys(context.appPrimaryColor)
        .map(
          (x) => Row(
            children: x.map(
              (y) {
                return Expanded(
                  child: KeyboardKey(
                    label: y,
                    value: y,
                    onTap: (val) {
                      if (val is Widget) {
                        onBackPress();
                      } else {
                        onKeyPress(val);
                      }
                    },
                  ),
                );
              },
            ).toList(),
          ),
        )
        .toList();
  }
}
