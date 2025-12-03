import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class CustomTitleBar extends StatelessWidget {
  final Widget? leading;
  final List<Widget>? actions;
  const CustomTitleBar({super.key, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
      child: Container(
        height: 32,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: leading!,
              ),
            ],
            Expanded(child: Container()),
            if (actions != null) ...actions!,
            WindowCaptionButton.minimize(
                onPressed: () => windowManager.minimize()),
            WindowCaptionButton.maximize(onPressed: () async {
              bool isMaximized = await windowManager.isMaximized();
              isMaximized
                  ? windowManager.unmaximize()
                  : windowManager.maximize();
            }),
            WindowCaptionButton.close(onPressed: () => windowManager.close()),
          ],
        ),
      ),
    );
  }
}