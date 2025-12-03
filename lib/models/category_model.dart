import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class CategoryModel {
  int? id;
  String name;
  String keyword;
  Color backgroundColor;
  int displayOrder;

  CategoryModel({
    this.id,
    required this.name,
    required this.keyword,
    required this.backgroundColor,
    this.displayOrder = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        keyword: json['keyword'],
        backgroundColor: colorFromHex(json['background_color'] ?? '#E3F2FD'),
        displayOrder: json['display_order'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'keyword': keyword,
        'background_color':
            '#${backgroundColor.value.toRadixString(16).substring(2).toUpperCase()}',
        'display_order': displayOrder,
      };
}