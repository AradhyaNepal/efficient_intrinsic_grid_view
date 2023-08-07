part of '../../widget.dart';


class _NormalDelegate extends SliverGridDelegate {
  const _NormalDelegate({
    required this.crossAxisCount,
    required this.crossAxisIntrinsicSize,
    required this.totalItems,
    required this.rebuildCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  }) : assert(crossAxisCount > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0);


  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;


  final int totalItems;

  ///Used to track if we need to rebuild the gridview
  final int rebuildCount;
  /// Overall max size of cross axis accordingly, Eg: If there is 2 item in the list, first item is max size of first crossAxis
  /// And Second item is max size of second crossAxis and so on..
  final List<double> crossAxisIntrinsicSize;

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
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
    return _IntrinsicCrossAxisTileLayout(
      crossAxisCount: crossAxisCount,
      crossAxisIntrinsicSize: crossAxisIntrinsicSize,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childCrossAxisExtent: childCrossAxisExtent,
      mainAxisSpacing: mainAxisSpacing,
      totalItems: totalItems,
    );
  }

  @override
  bool shouldRelayout(_NormalDelegate oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount
        || oldDelegate.mainAxisSpacing != mainAxisSpacing
        || oldDelegate.crossAxisSpacing != crossAxisSpacing
        || oldDelegate.rebuildCount!=rebuildCount;
  }
}




class _IntrinsicCrossAxisTileLayout extends SliverGridLayout {
  const _IntrinsicCrossAxisTileLayout({
    required this.crossAxisCount,
    required this.crossAxisStride,
    required this.childCrossAxisExtent,
    required this.crossAxisIntrinsicSize,
    required this.mainAxisSpacing,
    required this.totalItems,
  }) : assert(crossAxisCount > 0),
        assert(crossAxisStride >= 0),
        assert(childCrossAxisExtent >= 0);



  final int crossAxisCount;
  final double mainAxisSpacing;
  /// The number of pixels from the leading edge of one tile to the trailing
  /// edge of the same tile in the cross axis.
  final double childCrossAxisExtent;


  /// The number of pixels from the leading edge of one tile to the leading edge
  /// of the next tile in the cross axis.
  final double crossAxisStride;

  /// Overall max size of crossAxis accordingly, Eg: If there is 2 item in the list, first item is max size of first cross axis
  /// And Second item is max size of second crossAxis and so on..
  final List<double> crossAxisIntrinsicSize;
  final int totalItems;
  final int extraBuffer=1;

  ///When GridView scroll we do not need to render all items,
  /// because user only see limited screen at a particular time's scroll offset.
  ///
  /// This method is about, from which index start rendering, above this index item are not rendered.
  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    int fromWhichCrossAxisToStart=0;
    double fromThisMainAxis=0;
    while(fromThisMainAxis<scrollOffset){
      double currentMainAxisSize=crossAxisIntrinsicSize[fromWhichCrossAxisToStart]+mainAxisSpacing;
      fromThisMainAxis+=currentMainAxisSize;
      fromWhichCrossAxisToStart++;
    }
    fromWhichCrossAxisToStart-=extraBuffer;
    if(fromWhichCrossAxisToStart<0){
      fromWhichCrossAxisToStart=0;
    }
    return fromWhichCrossAxisToStart*crossAxisCount;
  }



  ///When GridView scroll we do not need to render all items,
  /// because user only see limited screen at a particular time's scroll offset.
  ///
  /// This method is about, from which index end rendering, below this index item are not rendered.
  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    int fromWhichCrossAxisToEnd=crossAxisIntrinsicSize.length-1;
    double fromThisMainAxis=_totalMainAxisItemSize;
    while(fromThisMainAxis>scrollOffset){
      double currentMainAxisSize=crossAxisIntrinsicSize[fromWhichCrossAxisToEnd]+mainAxisSpacing;
      fromThisMainAxis-=currentMainAxisSize;
      fromWhichCrossAxisToEnd--;
    }
   fromWhichCrossAxisToEnd+=1;//No Idea why
   fromWhichCrossAxisToEnd+=extraBuffer;
    int endItems=fromWhichCrossAxisToEnd*crossAxisCount;
    if(endItems>totalItems){
      endItems=totalItems;
    }
    return endItems-1;//No idea why its -1, but even in package its - 1. Without it last one value is not showing
  }

  double get _totalMainAxisItemSize => crossAxisIntrinsicSize.fold(0.0, (previousValue, element) => previousValue+element);


  /// The size and position of the child with the given index.
  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    int crossAxisIndex=index~/crossAxisCount;
    if(crossAxisIndex<=crossAxisIntrinsicSize.length-1){
      final double crossAxisStart = (index % crossAxisCount) * crossAxisStride;
      double specificCrossAxisIntrinsicSize=crossAxisIntrinsicSize[crossAxisIndex];
      double scrollOffset=0;
      for(int i=0;i<crossAxisIndex;i++){
        scrollOffset+=crossAxisIntrinsicSize[i]+mainAxisSpacing;
      }
      return SliverGridGeometry(
        scrollOffset: scrollOffset,
        crossAxisOffset: crossAxisStart,
        mainAxisExtent: specificCrossAxisIntrinsicSize,
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

  ///Total calculated mainAxisSize of the Gridview,
  ///counts from top to bottom even if its not rendered.
  ///
  /// Includes size of all cross axis in the grid view plus the middle padding/spacing between them.
  @override
  double computeMaxScrollOffset(int childCount) {
    final double totalMainAxisGapSize=mainAxisSpacing*(childCount~/crossAxisCount);
    return _totalMainAxisItemSize+totalMainAxisGapSize;
  }
}