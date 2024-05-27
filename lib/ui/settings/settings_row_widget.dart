import 'package:flutter/material.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class SettingsRowWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const SettingsRowWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            style: TextStyle(
                color: context.appPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: context.appPrimaryColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 16),
          const Divider(height: 0.5, thickness: 0),
        ]),
      ),
    );
  }
}
