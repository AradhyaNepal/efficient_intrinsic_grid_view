import 'package:flutter/material.dart';

import '../comman/utils.dart';

//Todo: Refactor variable to denote both cross axis and main axis scrolling
//Todo: Make this class private, secure it
//Todo: Optimize
///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
class IntrinsicSizeCalculator {
  ///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
  IntrinsicSizeCalculator();
  final List<double> _intrinsicMainAxisExtends = [];

  ///Unmodifiable list, do not try to modify it.
  List<double> get intrinsicMainAxisExtends =>
      List.unmodifiable(_intrinsicMainAxisExtends);

  ///To render the item in the widget tree, so that using keys of that items we can calculate max height.
  ///Items are hidden, since we have used Offstage widget
  Widget initByRendering({
    required VoidCallback onSuccess,
    required List<Widget> itemList,
    required int crossAxisItemsCount,
    required Axis axis,
  }) {
    _intrinsicMainAxisExtends.clear();
    // ignore: avoid_init_to_null
    Size? parentConstrain = null;
    int currentCrossAxisIndex = 0;
    int maxCrossAxisIndex =
        getCrossAxisCount(itemList.length, crossAxisItemsCount) - 1;
    //Todo: Make separate Widget
    return StatefulBuilder(
      builder: (context, setState) {
        if (parentConstrain == null) {
          return LayoutBuilder(builder: (context, constrain) {
            Future.delayed(Duration.zero, () {
              parentConstrain = Size(constrain.maxWidth, constrain.maxHeight);
              setState(() {});
            });
            return const SizedBox();
          });
        } else {
          Future.delayed(Duration.zero, () async {
            _intrinsicMainAxisExtends.add(
              await getOverallMaxHeight(
                crossAxisIndex: currentCrossAxisIndex,
                crossAxisKeyList: [], //Todo: WARNING, IMPLEMENT THIS FAST
                axis: axis,
              ),
            );
            if (currentCrossAxisIndex == maxCrossAxisIndex) {
              onSuccess();
            } else {
              currentCrossAxisIndex++;
              setState((){});
            }
          });
          //Todo: Change the entire rendering with key algorithm
          return Offstage(
            child: Flex(
              direction: axis,
              children: [
                for (int i = 0; i < itemList.length; i++)
                  SizedBox(
                    height: axis == Axis.horizontal
                        ? parentConstrain!.height / crossAxisItemsCount
                        : null,
                    width: axis == Axis.vertical
                        ? parentConstrain!.width / crossAxisItemsCount
                        : null,
                    child: const SizedBox(),//Todo: WARNING, IMPLEMENT THIS FAST
                  )
              ],
            ),
          );
        }
      },
    );
  }

  //Todo: Update document
  ///Must call initByRendering Using latest value of serviceList and render the returned value, before calling this method.
  ///
  /// Returns Overall max height row accordingly, Eg: If there is 2 item in the list, first item is max height of first Row
  /// And Second item is max height of second height and so on..
  Future<double> getOverallMaxHeight({
    required int crossAxisIndex, //Todo: Document
    required List<GlobalKey> crossAxisKeyList,
    required Axis axis,
  }) async {
    await Future.delayed(Duration.zero); //To make sure items are rendered
    double maxMainAxisExtend = 0;
    for (var key in crossAxisKeyList) {
      final size = (key.currentContext?.findRenderObject() as RenderBox).size;
      double currentMainAxisExtend =
          axis == Axis.vertical ? size.height : size.width;
      if (currentMainAxisExtend > maxMainAxisExtend) {
        maxMainAxisExtend = currentMainAxisExtend;
      }
    }
    return maxMainAxisExtend;
  }
}
