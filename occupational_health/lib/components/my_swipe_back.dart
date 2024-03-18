import "package:flutter/material.dart";

class MySwipeBack extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const MySwipeBack({Key? key, required this.child, this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (enabled && details.primaryDelta! > 20) {
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
