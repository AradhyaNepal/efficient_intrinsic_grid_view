import 'package:flutter/material.dart';

//Todo: Refactor variable to denote both cross axis and main axis scrolling
///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
class IntrinsicSizeCalculator {
  List<Widget> itemList;
  int crossAxisCount;
  Axis axis;

  ///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
  IntrinsicSizeCalculator({
    required this.itemList,
    required this.crossAxisCount,
    required this.axis,
  });

  final List<GlobalKey> _keysList = [];
  final List<Widget> _renderList = [];

  ///To render the item in the widget tree, so that using keys of that items we can calculate max height.
  ///Items are hidden, since we have used Offstage widget
  Widget initByRendering({required VoidCallback onSuccess}) {
    _renderList.clear();
    _keysList.clear();
    for (int index = 0; index < itemList.length; index++) {
      final globalKey = GlobalKey();
      _renderList.add(SizedBox(
        key: globalKey,
        child: itemList[index],
      ));
      _keysList.add(globalKey);
    }


    // ignore: avoid_init_to_null
    Size? parentConstrain=null;
    return StatefulBuilder(
      builder: (context, setState) {
        if(parentConstrain==null){
          return LayoutBuilder(
            builder: (context,constrain) {
              Future.delayed(Duration.zero,(){
                parentConstrain=Size(constrain.maxWidth,constrain.maxHeight);
                setState((){});
              });
              return const SizedBox();
            }
          );
        }else{
          Future.delayed(Duration.zero,(){

            onSuccess();
          });
          //Todo: Is this efficient, if no than make it efficient.
          //Todo: Do performance testing
          //Todo: What if gridview have only half width or half height, use key to first find parent constrains
          return Offstage(
            child: Flex(
              direction: axis,
              children: [
                for (int i = 0; i < itemList.length; i++)
                  SizedBox(
                    height: axis==Axis.horizontal?parentConstrain!.height/crossAxisCount:null,
                    width: axis==Axis.vertical?parentConstrain!.width/crossAxisCount:null,
                    child: _renderList[i],
                  )
              ],
            ),
          );
        }
      },
    );
  }

  ///Must call initByRendering Using latest value of serviceList and render the returned value, before calling this method.
  ///
  /// Returns Overall max height row accordingly, Eg: If there is 2 item in the list, first item is max height of first Row
  /// And Second item is max height of second height and so on..
  Future<List<double>> getOverallMaxHeight() async {
    await Future.delayed(Duration
        .zero); //To make sure initRendering had rendered the widgets, and only after rendering below code is run
    List<double> rowMaxHeightList = [];
    for (int row = 0; row < _keysList.length; row += crossAxisCount) {
      double rowMaxHeight = 0;
      for (int column = 0; column < crossAxisCount; column++) {
        int overallIndex = row + column;
        if (overallIndex > _keysList.length - 1) {
          rowMaxHeightList.add(rowMaxHeight);
          return rowMaxHeightList;
        } else {
          final size = (_keysList[overallIndex]
                  .currentContext
                  ?.findRenderObject() as RenderBox)
              .size;
          double currentHeight =
              axis == Axis.vertical ? size.height : size.width;
          if (currentHeight > rowMaxHeight) {
            rowMaxHeight = currentHeight;
          }
        }
      }

      rowMaxHeightList.add(rowMaxHeight);
    }
    return rowMaxHeightList;
  }
}
