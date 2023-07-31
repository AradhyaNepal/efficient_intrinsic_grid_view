import 'dart:math' as math;
import 'package:flutter/rendering.dart';

//Todo: Make it for horizontal scrolling too
///Only use it for Vertical Scrolling.
///
///We can provide different height of each row using this Delegate
class IntrinsicDelegate extends SliverGridDelegate {
  const IntrinsicDelegate({
    required this.crossAxisCount,
    required this.rowsIntrinsicHeight,
    required this.totalItems,
    required this.gridViewRowHeightRefresh,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  }) : assert(crossAxisCount > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0),
        assert(childAspectRatio > 0);


  //Todo: Copy paste official
  //See flutter official docs to understand below variable
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  ///Used to track if we need to rebuild the gridview
  final int gridViewRowHeightRefresh;
  final int totalItems;

  /// Overall max height row accordingly, Eg: If there is 2 item in the list, first item is max height of first Row
  /// And Second item is max height of second height and so on..
  final List<double> rowsIntrinsicHeight;

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(childAspectRatio > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final double usableCrossAxisExtent = math.max(
      0.0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    return IntrinsicRowTileLayout(
      crossAxisCount: crossAxisCount,
      rowIntrinsicHeights: rowsIntrinsicHeight,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: false,
      mainAxisSpacing: mainAxisSpacing,
      totalItems: totalItems,
    );
  }

  @override
  bool shouldRelayout(IntrinsicDelegate oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount
        || oldDelegate.mainAxisSpacing != mainAxisSpacing
        || oldDelegate.crossAxisSpacing != crossAxisSpacing
        || oldDelegate.childAspectRatio != childAspectRatio
        || oldDelegate.gridViewRowHeightRefresh!=gridViewRowHeightRefresh;
  }
}




class IntrinsicRowTileLayout extends SliverGridLayout {
  const IntrinsicRowTileLayout({
    required this.crossAxisCount,
    required this.crossAxisStride,
    required this.childCrossAxisExtent,
    required this.reverseCrossAxis,
    required this.rowIntrinsicHeights,
    required this.mainAxisSpacing,
    required this.totalItems,
  }) : assert(crossAxisCount > 0),
        assert(crossAxisStride >= 0),
        assert(childCrossAxisExtent >= 0);


  //See flutter official docs to understand below variable
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double childCrossAxisExtent;
  final bool reverseCrossAxis;
  final double crossAxisStride;

  /// Overall max height row accordingly, Eg: If there is 2 item in the list, first item is max height of first Row
  /// And Second item is max height of second height and so on..
  final List<double> rowIntrinsicHeights;
  final int totalItems;

  ///When GridView scroll we do not need to render all items,
  /// because user only see limited screen at a particular time's scroll offset.
  ///
  /// This method is about, from which index start rendering, above this index item are not rendered.
  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    int fromWhichRowToStart=0;
    double height=0;
    while(height<scrollOffset){
      double currentRowHeight=rowIntrinsicHeights[fromWhichRowToStart]+mainAxisSpacing;
      height+=currentRowHeight;
      fromWhichRowToStart++;
    }
    if(fromWhichRowToStart<0){
      fromWhichRowToStart=0;
    }
    return fromWhichRowToStart*crossAxisCount;
  }



  ///When GridView scroll we do not need to render all items,
  /// because user only see limited screen at a particular time's scroll offset.
  ///
  /// This method is about, from which index end rendering, below this index item are not rendered.
  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    int fromWhichRowToEnd=rowIntrinsicHeights.length-1;
    double height=_totalHeight;
    while(height>scrollOffset){
      double currentRowHeight=rowIntrinsicHeights[fromWhichRowToEnd]+mainAxisSpacing;
      height-=currentRowHeight;
      fromWhichRowToEnd--;
    }
   fromWhichRowToEnd+=1;//Without +1, last one row item not showing
    int endItems=fromWhichRowToEnd*crossAxisCount;
    if(endItems>totalItems){
      endItems=totalItems;
    }
    return endItems-1;//No idea why its -1, but even in package its - 1. Without it last one value is not showing
  }

  double get _totalHeight => rowIntrinsicHeights.fold(0.0, (previousValue, element) => previousValue+element);


  //See official flutter docs
  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    int rowIndex=index~/crossAxisCount;
    if(rowIndex<=rowIntrinsicHeights.length-1){
      final double crossAxisStart = (index % crossAxisCount) * crossAxisStride;
      double maxHeightOfThatRow=rowIntrinsicHeights[rowIndex];
      double scrollOffset=0;
      for(int i=0;i<rowIndex;i++){
        scrollOffset+=rowIntrinsicHeights[i]+mainAxisSpacing;
      }
      return SliverGridGeometry(
        scrollOffset: scrollOffset,
        crossAxisOffset: crossAxisStart,
        mainAxisExtent: maxHeightOfThatRow,
        crossAxisExtent: childCrossAxisExtent,
      );
    }else{
      return const SliverGridGeometry(
        scrollOffset: 0,
        crossAxisOffset: 0,
        mainAxisExtent: 0,
        crossAxisExtent: 0,
      );
    }
  }

  ///Total offset height of the Gridview,
  ///counts from top to bottom even if its not rendered.
  ///
  /// Includes height of all rows in the grid view plus the middle padding/spacing between each row
  @override
  double computeMaxScrollOffset(int childCount) {
    final double totalGapHeightCovered=mainAxisSpacing*(childCount~/crossAxisCount);
    final double totalChildHeightCovered=_totalHeight;
    return totalChildHeightCovered+totalGapHeightCovered;
  }
}