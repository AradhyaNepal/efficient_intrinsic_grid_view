import 'package:efficient_intrinsic_gridview/src/controller_inherited_widget.dart';
import 'package:flutter/material.dart';
import '../efficient_intrinsic_gridview.dart';

///This gridview uses GridView.builder to be efficient, so it will only render widget which user sees, plus some other for buffer.
class EfficientIntrinsicGridView extends StatelessWidget {
  final IntrinsicController controller;
  ///Wraps widget with extra SingleChildScrollView to prevent overflow
  ///It is used when a stateful widget is passed inside the items, and the size of the widget might change as user interact
  final bool preventOverflow;


  const EfficientIntrinsicGridView({
    super.key,
    required this.controller,
    this.preventOverflow=false,
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
                        final child=controller.widgetList[index];
                        if(preventOverflow){
                          return SingleChildScrollView(child:child );//Todo: Add physics
                        }else{
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
