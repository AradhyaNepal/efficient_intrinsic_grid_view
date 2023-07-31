import 'package:flutter/material.dart';

import 'utils/intrinsic_gridview_controller.dart';

class IntrinsicGridView extends StatelessWidget {
  final IntrinsicGridviewController controller;

  const IntrinsicGridView({
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
