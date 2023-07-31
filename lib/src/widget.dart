import 'package:flutter/material.dart';
import '../efficient_intrinsic_grid_view.dart';

///This gridview uses GridView.builder to be efficient, so it will only render widget which user sees, plus some other for buffer.
class EfficientIntrinsicGridView extends StatelessWidget {
  final IntrinsicController controller;

  const EfficientIntrinsicGridView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context,isLoading,child){
        if(isLoading){
          controller.calculateMaxHeight();
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              controller.initRendering(),
            ],
          );
        }
        return GridView.builder(
          gridDelegate:controller.intrinsicRowGridDelegate,
          itemBuilder: (context, index) {
            return controller.widgetList[index];
          },
          itemCount: controller.widgetList.length,
        );
      },
    );
  }
}
