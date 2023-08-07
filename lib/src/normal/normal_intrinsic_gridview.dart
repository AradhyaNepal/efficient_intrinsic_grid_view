part of '../widget.dart';

class _NormalIntrinsicGridView extends EfficientIntrinsicGridView {
  final IntrinsicController controller;

  ///Wraps widget with extra SingleChildScrollView to prevent overflow
  ///It is used when a stateful widget is passed inside the items, and the size of the widget might change as user interact
  final bool preventOverflow;
  final GridViewInput gridViewInput;

  _NormalIntrinsicGridView({
    Key? key,
    required this.controller,
    required this.preventOverflow,
    GridViewInput? gridViewInput,
  })  : gridViewInput = gridViewInput ?? GridViewInput(),
        super._init(key: key);

  @override
  Widget build(BuildContext context) {
    // if(controller._widgetList.isEmpty)return const SizedBox();
    return ControllerInheritedWidget(
      controller: controller,
      child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, isLoading, child) {
            return Column(
              children: [
                if (controller.value) controller.renderAndCalculate(),
                if (controller.canDisplayGridView)
                  Expanded(
                    child: GridView.builder(
                      scrollDirection: controller._axis,
                      gridDelegate: controller.intrinsicRowGridDelegate,
                      reverse: gridViewInput.reverse,
                      controller: gridViewInput.controller,
                      primary: gridViewInput.primary,
                      physics: gridViewInput.physics,
                      // super.padding,//Todo: Implement
                      // cacheExtent: 1,//Todo: No need to Implement
                      findChildIndexCallback:
                          gridViewInput.findChildIndexCallback,
                      addAutomaticKeepAlives:
                          gridViewInput.addAutomaticKeepAlives,
                      addRepaintBoundaries: gridViewInput.addRepaintBoundaries,
                      addSemanticIndexes: gridViewInput.addSemanticIndexes,
                      semanticChildCount: gridViewInput.semanticChildCount,
                      dragStartBehavior: gridViewInput.dragStartBehavior,
                      keyboardDismissBehavior:
                          gridViewInput.keyboardDismissBehavior,
                      restorationId: gridViewInput.restorationId,
                      clipBehavior: gridViewInput.clipBehavior,
                      itemBuilder: (context, index) {
                        final child = controller.widgetList[index];
                        if (preventOverflow) {
                          return SingleChildScrollView(
                            scrollDirection: controller._axis,
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
