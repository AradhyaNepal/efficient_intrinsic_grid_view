import 'package:flutter/material.dart';

///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
class IntrinsicSizeCalculator{
  final List<Widget> itemList;
  final int columnCount;

  ///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
  IntrinsicSizeCalculator({
    required this.itemList,
    required this.columnCount,
  });


  final List<GlobalKey> _keysList=[];
  final List<Widget> _renderList=[];
  ///To render the item in the widget tree, so that using keys of that items we can calculate max height.
  ///Items are hidden, since we have used Offstage widget
  Widget initByRendering(){
    Offstage widget;
    _renderList.clear();
    _keysList.clear();
    for(int index=0;index<itemList.length;index++){
      final globalKey=GlobalKey();
      _renderList.add(
          SizedBox(
            key:globalKey,
            child: itemList[index],
          )
      );
      _keysList.add(globalKey);
    }
    widget= Offstage(
      child: Column(
        children:[
          for(int i=0;i<itemList.length;i++)
            _renderList[i],
        ],
      ),
    );
    return widget;
  }




  ///Must call initByRendering Using latest value of serviceList and render the returned value, before calling this method.
  ///
  /// Returns Overall max height row accordingly, Eg: If there is 2 item in the list, first item is max height of first Row
  /// And Second item is max height of second height and so on..
  Future<List<double>> getOverallMaxHeight() async{
    await Future.delayed(Duration.zero); //To make sure initRendering had rendered the widgets, and only after rendering below code is run
    List<double> rowMaxHeightList=[];
    for(int row=0;row<_keysList.length;row+=columnCount){
      double rowMaxHeight=0;
      for(int column=0;column<columnCount;column++){
        int overallIndex=row+column;
        if(overallIndex>_keysList.length-1){
          rowMaxHeightList.add(rowMaxHeight);
          return rowMaxHeightList;
        }else{
          double currentHeight=(_keysList[overallIndex].currentContext?.findRenderObject() as RenderBox).size.height;
          if(currentHeight>rowMaxHeight){
            rowMaxHeight=currentHeight;
          }
        }
      }
      rowMaxHeightList.add(rowMaxHeight);
    }
    return rowMaxHeightList;
  }
}






