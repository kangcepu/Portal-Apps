import 'package:flutter/material.dart';
import '../models/app_model.dart';
import 'app_item.dart';

class UtilityGridView extends StatelessWidget {
  final List<AppModel> apps;
  const UtilityGridView({super.key, required this.apps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: apps.map((app) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: AppItem(app: app),
            ),
          ),
        );
      }).toList(),
    );
  }
}