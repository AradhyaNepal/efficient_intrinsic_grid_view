import 'package:efficient_intrinsic_gridview/src/controller_inherited_widget.dart';
import 'package:flutter/material.dart';
import '../efficient_intrinsic_gridview.dart';

///This gridview uses GridView.builder to be efficient, so it will only render widget which user sees, plus some other for buffer.
class EfficientIntrinsicGridView extends StatelessWidget {
  final IntrinsicController controller;

  const EfficientIntrinsicGridView({
    super.key,
    required this.controller,
  });

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
                      Future.delayed(Duration.zero,(){
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
                        return controller.widgetList[index];
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
