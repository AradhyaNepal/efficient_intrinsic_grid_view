import 'package:efficient_intrinsic_gridview/src/controller_inherited_widget.dart';
import 'package:flutter/material.dart';
import '../efficient_intrinsic_gridview.dart';
import 'enum.dart';

///This gridview uses GridView.builder to be efficient, so it will only render widget which user sees, plus some other for buffer.
class EfficientIntrinsicGridView extends StatelessWidget {
  final IntrinsicController controller;

  //Todo: Add comment
  final RenderPrevention renderPrevention;

  const EfficientIntrinsicGridView({
    super.key,
    required this.controller,
    this.renderPrevention = RenderPrevention.none,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.widgetList.isEmpty) return const SizedBox();
    return ControllerInheritedWidget(
      controller: controller,
      renderPrevention: renderPrevention,
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
                        return switch (renderPrevention) {
                          //Todo: Might User ListView instead
                          RenderPrevention.hListview => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: child,
                            ),
                          RenderPrevention.vListview => SingleChildScrollView(
                            child: child,
                            ),
                        RenderPrevention.twoDListview=>SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: child,
                          ),
                        ),
                          _ => child,
                        };
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
