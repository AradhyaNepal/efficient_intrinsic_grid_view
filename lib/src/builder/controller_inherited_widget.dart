import 'package:efficient_intrinsic_gridview/efficient_intrinsic_gridview.dart';
import 'package:flutter/material.dart';

class ControllerInheritedWidget extends InheritedWidget {
  const ControllerInheritedWidget({
    super.key,
    required this.controller,
    required super.child,
  });


  final NormalIntrinsicController controller;

  static ControllerInheritedWidget? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ControllerInheritedWidget>();
  }

  static NormalIntrinsicController getController(BuildContext context) {
    final ControllerInheritedWidget? result = maybeOf(context);
    assert(result != null, 'No Controller Found');
    return result!.controller;
  }


  @override
  bool updateShouldNotify(ControllerInheritedWidget oldWidget) =>
      controller != oldWidget.controller;
}
