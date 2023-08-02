import 'package:efficient_intrinsic_gridview/src/controller_inherited_widget.dart';
import 'package:flutter/material.dart';
import '../efficient_intrinsic_gridview.dart';

part 'grid_using_column_row.dart';

///This gridview uses GridView.builder to be efficient, so it will only render widget which user sees, plus some other for buffer.
abstract class EfficientIntrinsicGridView extends StatelessWidget {
  const EfficientIntrinsicGridView._init({super.key});

  factory EfficientIntrinsicGridView({
    Key? key,
    required IntrinsicController controller,
    bool preventOverflow = false,
  }) =>
      _NormalWidget(controller: controller);

  factory EfficientIntrinsicGridView.builder({
    Key? key,
    required IntrinsicController controller,
    bool preventOverflow = false,
  }) =>
      _BuilderWidget(
        key: key,
      );

  //Todo: Comment and test
  factory EfficientIntrinsicGridView.shrinkWrap({
    Key? key,
    required Widget Function(BuildContext, int) itemBuilder,
    required int itemCount,
    int columnCounts = 2,
    double? leftPadding,
    bool alignColumnWise = true, //Todo: Use Axis instead
  }) =>
      _GridUsingColumnRow(
        key: key,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        columnCounts: columnCounts,
        leftPadding: leftPadding,
        alignColumnWise: alignColumnWise,
      );
}

class _NormalWidget extends EfficientIntrinsicGridView {
  final IntrinsicController controller;

  ///Wraps widget with extra SingleChildScrollView to prevent overflow
  ///It is used when a stateful widget is passed inside the items, and the size of the widget might change as user interact
  final bool preventOverflow;

  const _NormalWidget({
    Key? key,
    required this.controller,
    this.preventOverflow = false,
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
                            scrollDirection: controller.axis,
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

class _BuilderWidget extends EfficientIntrinsicGridView {
  const _BuilderWidget({
    Key? key,
  }) : super._init(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
