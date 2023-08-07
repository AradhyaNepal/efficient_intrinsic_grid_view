part of '../../widget.dart';

class _NormalIntrinsicGridView extends EfficientIntrinsicGridView {
  final NormalIntrinsicController controller;

  ///Wraps widget with extra SingleChildScrollView to prevent overflow
  ///It is used when a stateful widget is passed inside the items, and the size of the widget might change as user interact
  final bool preventOverflow;
  final GridViewInput gridViewInput;
  final bool autoMainAxisSize;

  _NormalIntrinsicGridView({
    Key? key,
    required this.controller,
    required this.preventOverflow,
    required this.autoMainAxisSize,
    GridViewInput? gridViewInput,
  })  : gridViewInput = gridViewInput ?? GridViewInput(),
        super._init(key: key);

  @override
  Widget build(BuildContext context) {
    return ControllerInheritedWidget(
      controller: controller,
      child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, isLoading, child) {
            return SizedBox(
              height: controller._axis == Axis.vertical && _canCalculateAutoSize
                  ? controller.totalMainAxisSize
                  : null,
              width:
                  controller._axis == Axis.horizontal && _canCalculateAutoSize
                      ? controller.totalMainAxisSize
                      : null,
              child: Column(
                children: [
                  if (controller.value) controller.renderAndCalculate(),
                  if (controller.canDisplayGridView)
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: controller._axis,
                        gridDelegate: controller._delegate,
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
                        addRepaintBoundaries:
                            gridViewInput.addRepaintBoundaries,
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
                          //Todo: Make vertical horizontal prevention. 2D scrolling
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
              ),
            );
          }),
    );
  }

  bool get _canCalculateAutoSize =>
      controller.canDisplayGridView && autoMainAxisSize;
}



// height: controller._axis == Axis.horizontal
// ? controller.parentConstraints.height /
// controller._crossAxisCount
//     : double.infinity,
// width: controller._axis == Axis.vertical
// ? controller.parentConstraints.width /
// controller._crossAxisCount
//     :double.infinity,