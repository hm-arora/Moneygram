import 'package:flutter/material.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class KeyboardKey extends StatefulWidget {
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  const KeyboardKey({
    Key? key,
    required this.label,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  renderLabel() {
    if (widget.label is Widget) {
      return widget.label;
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        widget.label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height / 15;
    print(size);
    return Material(
        color: context.appSecondaryColor,
        child: Container(
          height: size,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: context.appPrimaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6)),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              widget.onTap(widget.value);
            },
            child: renderLabel(),
          ),
        ));
  }
}
