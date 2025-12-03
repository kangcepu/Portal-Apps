import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class AppModel {
  int? id;
  String name;
  String? description;
  String iconPath;
  String executablePath;
  Color borderColor;
  String appGroup;
  int displayOrder;

  AppModel({
    this.id,
    required this.name,
    this.description,
    required this.iconPath,
    required this.executablePath,
    required this.borderColor,
    required this.appGroup,
    this.displayOrder = 0,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        iconPath: json['icon_path'],
        executablePath: json['executable_path'],
        borderColor: colorFromHex(json['border_color_hex']),
        appGroup: json['app_group'],
        displayOrder: json['display_order'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon_path': iconPath,
        'executable_path': executablePath,
        'border_color_hex':
            '#${borderColor.value.toRadixString(16).substring(2).toUpperCase()}',
        'app_group': appGroup,
        'display_order': displayOrder,
      };
}