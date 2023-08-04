import 'package:flutter/material.dart';

//Todo: Refactor variable to denote both cross axis and main axis scrolling
//Todo: Make this class private, secure it
//Todo: Optimize
///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
class IntrinsicSizeCalculator {
  ///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
  IntrinsicSizeCalculator();

  final List<GlobalKey> _keysList = []; //Todo: Remove this key
  final List<Widget> _renderList = []; //Todo: Remove this list
  final List<double> _intrinsicMainAxisExtends = [];

  ///Unmodifiable list, do not try to modify it.
  List<double> get intrinsicMainAxisExtends =>
      List.unmodifiable(_intrinsicMainAxisExtends);

  ///To render the item in the widget tree, so that using keys of that items we can calculate max height.
  ///Items are hidden, since we have used Offstage widget
  Widget initByRendering({
    required VoidCallback onSuccess,
    required List<Widget> itemList,
    required int crossAxisCount,
    required Axis axis,
  }) {
    _renderList.clear();
    _keysList.clear();
    _intrinsicMainAxisExtends.clear();
    for (int index = 0; index < itemList.length; index++) {
      final globalKey = GlobalKey();
      _renderList.add(SizedBox(
        key: globalKey,
        child: itemList[index],
      ));
      _keysList.add(globalKey);
    }

    // ignore: avoid_init_to_null
    Size? parentConstrain = null;
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
          Future.delayed(Duration.zero, () {
            onSuccess();
          });
          //Todo: Do Performance testing
          //  And in research and development branch, implement
          // another way where crossAxisCount items are rendered and max value calculated, one by one.
          //Right now everything is happening at once, which is causing high jank on UI,
          //What if there are many items, my widget might perform bad.
          return Offstage(
            child: Flex(
              direction: axis,
              children: [
                for (int i = 0; i < itemList.length; i++)
                  SizedBox(
                    height: axis == Axis.horizontal
                        ? parentConstrain!.height / crossAxisCount
                        : null,
                    width: axis == Axis.vertical
                        ? parentConstrain!.width / crossAxisCount
                        : null,
                    child: _renderList[i],
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
  Future<void> getOverallMaxHeight({
    required int crossAxisIndex, //Todo: Document
    required List<GlobalKey> crossAxisKeyList,
    required Axis axis,
  }) async {
    await Future.delayed(
        Duration.zero); //To make sure items are rendered
    double maxMainAxisExtend = 0;
    for (var key in crossAxisKeyList) {
      final size = (key.currentContext?.findRenderObject() as RenderBox).size;
      double currentMainAxisExtend =
          axis == Axis.vertical ? size.height : size.width;
      if (currentMainAxisExtend > maxMainAxisExtend) {
        maxMainAxisExtend = currentMainAxisExtend;
      }
    }
    _intrinsicMainAxisExtends.add(maxMainAxisExtend);
  }
}
