import 'package:flutter/material.dart';

class KeyboardHelper {
  static List<List<dynamic>> getKeys(Color color) {
    return [
      ['1', '2', '3'],
      ['4', '5', '6'],
      [
        '7',
        '8',
        '9',
      ],
      [
        '.',
        '0',
        Icon(
          Icons.backspace_outlined,
          color: color,
        ),
      ],
    ];
  }
}
