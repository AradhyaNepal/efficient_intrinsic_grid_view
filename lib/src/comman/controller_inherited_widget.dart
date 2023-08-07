part of '../../widget.dart';

//Todo: Make it generic
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
