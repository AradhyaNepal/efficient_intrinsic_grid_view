import 'package:flutter/material.dart';
import 'package:intrinsic_gridview/intrinsic_gridview/utils/intrinsic_row_grid_delegate.dart';

import '../utils/intrinsic_height_calculator.dart';

class IntrinsicGridviewController extends ValueNotifier<bool> {
  final int columnCount;
  final List<Widget> widgetList;
  late IntrinsicHeightCalculator _intrinsicHeightCalculator;

  IntrinsicRowGridDelegate get intrinsicRowGridDelegate =>
      IntrinsicRowGridDelegate(
        crossAxisCount: 3,
        rowsIntrinsicHeight: rowsIntrinsicHeight,
        totalItems: widgetList.length,
        gridViewRowHeightRefresh: 0,
      );
  List<double> _rowsIntrinsicHeight = [];

  ///Empty List means its loading.
  ///
  ///Have caching, till the new value is not calculated, use same previous value.
  List<double> get rowsIntrinsicHeight => _rowsIntrinsicHeight;

  bool get isLoading => rowsIntrinsicHeight.isEmpty;

  Widget initRendering() => _intrinsicHeightCalculator.initByRendering();

  IntrinsicGridviewController({
    required this.columnCount,
    required this.widgetList,
  }) : super(true) {
    _intrinsicHeightCalculator = IntrinsicHeightCalculator(
      itemList: widgetList,
      columnCount: columnCount,
    );
  }

  /// Calculate maxHeight in next stack.
  ///
  /// Make sure to call initByRendering before it.
  /// (Or just one stack after it but Synchronous, since this method perform task in next stack)
  ///
  /// ->UI Uses Old Cache Max Height List while New Max Height is being calculated <-
  Future<void> calculateMaxHeight() async {
    //Delay to calculate Height in next frame after initRendering is done,
    // else max height is calculated using old data.
    await Future.delayed(Duration.zero);
    _rowsIntrinsicHeight =
        await _intrinsicHeightCalculator.getOverallMaxHeight();
    print("Rebuild");
    super.value = false;
  }
}
