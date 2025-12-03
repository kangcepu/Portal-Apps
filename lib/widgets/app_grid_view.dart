import 'package:flutter/material.dart';
import '../models/app_model.dart';
import 'app_item.dart';

class AppGridView extends StatelessWidget {
  final List<AppModel> apps;
  const AppGridView({super.key, required this.apps});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20.0,
        runSpacing: 20.0,
        children: apps
            .map((app) => SizedBox(
                  width: 160,
                  height: 160,
                  child: AppItem(app: app),
                ))
            .toList(),
      ),
    );
  }
}