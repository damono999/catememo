import 'package:flutter/material.dart';

class ColorEnum {
  final int id;
  final String name;
  final Color color;

  ColorEnum(
    this.id,
    this.name,
    this.color,
  );
}

class ColorEnumList {
  static List<ColorEnum> colorEnum = [
    ColorEnum(1, '赤', Colors.red),
    ColorEnum(2, '緑', Colors.green),
    ColorEnum(3, '青', Colors.blue),
    ColorEnum(4, 'オレンジ', Colors.orange),
    ColorEnum(5, '黄色', Colors.yellow),
    ColorEnum(6, '紫', Colors.purple),
    ColorEnum(7, 'ピンク', Colors.pink),
    ColorEnum(8, '黄緑', Colors.lightGreen),
    ColorEnum(9, '水色', Colors.lightBlue),
    ColorEnum(99, '灰色', Colors.grey),
  ];

  static List<ColorEnum> get getEnum {
    return [...colorEnum];
  }

  static ColorEnum getTargetCategory(int colorId) {
    return colorEnum.firstWhere((e) => e.id == colorId);
  }

  static ColorEnum get getBlank {
    return ColorEnum(0, '', Colors.grey[300]);
  }
}
