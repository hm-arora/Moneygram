import 'package:flutter/material.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class AlertDialogView extends StatelessWidget {
  final String title;
  final String description;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onTapLeftButton;
  final VoidCallback onTapRightButton;

  const AlertDialogView({
    Key? key,
    required this.title,
    required this.description,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onTapLeftButton,
    required this.onTapRightButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.appPrimaryColor,
                fontSize: 20)),
        const SizedBox(height: 12),
        Text(description),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          _buildButton(context, text: leftButtonText, callback: onTapLeftButton),
          const SizedBox(width: 12),
          _buildButton(context, text: rightButtonText, callback: onTapRightButton),
        ])
      ],
    ));
  }

  Widget _buildButton(BuildContext context, {required String text, required VoidCallback callback}) {
    return InkWell(
      onTap: callback,
      borderRadius: BorderRadius.circular(4),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.appPrimaryColor, width: 0.5)),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          child: Text(text)),
    );
  }
}
