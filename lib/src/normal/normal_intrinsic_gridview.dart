part of '../widget.dart';
class _NormalIntrinsicGridView extends EfficientIntrinsicGridView {
  final IntrinsicController controller;

  ///Wraps widget with extra SingleChildScrollView to prevent overflow
  ///It is used when a stateful widget is passed inside the items, and the size of the widget might change as user interact
  final bool preventOverflow;

  const _NormalIntrinsicGridView({
    Key? key,
    required this.controller,
    required this.preventOverflow
  }) : super._init(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.widgetList.isEmpty) return const SizedBox();
    return ControllerInheritedWidget(
      controller: controller,
      child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, isLoading, child) {
            return Column(
              children: [
                if (isLoading)
                  Builder(
                    builder: (context) {
                      Future.delayed(Duration.zero, () {
                        controller.calculateMaxHeight();
                      });
                      return controller.initRendering();
                    },
                  ),
                if (controller.isInitialized)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: controller.intrinsicRowGridDelegate,
                      itemBuilder: (context, index) {
                        final child = controller.widgetList[index];
                        if (preventOverflow) {
                          return SingleChildScrollView(
                            child: child,
                          );
                        } else {
                          return child;
                        }
                      },
                      itemCount: controller.widgetList.length,
                    ),
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            );
          }),
    );
  }
}