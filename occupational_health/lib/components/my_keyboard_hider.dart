import 'package:flutter/widgets.dart';

/// A widget that upon tap attempts to hide the keyboard.
class MyKeyboardHider extends StatelessWidget {
  /// Creates a widget that on tap, hides the keyboard.
  const MyKeyboardHider({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
