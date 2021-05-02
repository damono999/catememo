import 'package:flutter/material.dart';

class CategoryEnum {
  final int id;
  final String name;
  final Color color;
  final IconData icon;

  CategoryEnum(
    this.id,
    this.name,
    this.color,
    this.icon,
  );
}

class CategoryEnumList {
  static List<CategoryEnum> categoryEnum = [
    CategoryEnum(1, '恋愛', Colors.red, Icons.favorite),
    CategoryEnum(2, '読書', Colors.green, Icons.book),
    CategoryEnum(3, '時間術', Colors.blueGrey, Icons.timer),
    CategoryEnum(4, 'お金', Colors.orange, Icons.monetization_on),
    CategoryEnum(5, 'ビジネス', Colors.amberAccent, Icons.business),
    CategoryEnum(6, 'スケジュール', Colors.blue[100], Icons.schedule),
    CategoryEnum(7, '健康', Colors.lightGreen, Icons.star),
    CategoryEnum(99, '不明', Colors.grey[200], Icons.help_outline),
  ];

  static List<CategoryEnum> get getEnum {
    return [...categoryEnum];
  }

  static CategoryEnum getTargetCategory(int categoryId) {
    return categoryEnum.firstWhere((e) => e.id == categoryId);
  }

  static CategoryEnum get getBlank {
    return CategoryEnum(0, '', Colors.grey[300], null);
  }
}
