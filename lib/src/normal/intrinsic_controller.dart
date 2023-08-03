part of '../widget.dart';
//Todo: Variable refactor to denote both horizontal and vertical scrolling
class IntrinsicController extends ValueNotifier<bool> {
  var _beenInitializedOnce=false;//Make completer
  final Axis axis;
  final int columnCount;
  List<Widget> _widgetList = [];

  ///Returns unmodifiable list, so you cannot update it.
  ///If you want to update it, you have to use the setter method
  List<Widget> get widgetList => List.unmodifiable(_widgetList);

  ///On Value updated, widgets get rebuild,
  ///and intrinsic height are recalculated
  set widgetList(List<Widget> newValue) {
    _intrinsicHeightCalculator.itemList = newValue;
    super.value = true;
    super.addListener(() {
      if (!super.value) {
        _widgetList = newValue;
      }
    });
  }

  //Todo: Make it work, and logic verify
  void _onGridviewConstructed({
    required bool preventRebuild,
    required List<Widget> widgets,
  }) {
    if(!(_beenInitializedOnce && preventRebuild)){
      widgetList=widgets;
    }
  }

  //Todo: Currently excluding gap, why??
  double get getSize => _rowsIntrinsicHeight.fold(
      0, (previousValue, element) => previousValue + element);

  late IntrinsicSizeCalculator _intrinsicHeightCalculator;

  int _refreshCount = 0;

  IntrinsicDelegate get intrinsicRowGridDelegate => IntrinsicDelegate(
        crossAxisCount: 3,
        crossAxisIntrinsicSize: _rowsIntrinsicHeight,
        totalItems: widgetList.length,
        crossAxisSizeRefresh: _refreshCount,
      );
  List<double> _rowsIntrinsicHeight = [];

  bool get isInitialized => _rowsIntrinsicHeight.isNotEmpty;

  Widget initRendering() {
    if (!super.value) return const SizedBox();
    print("Was here");

    return _intrinsicHeightCalculator.initByRendering();
  }

  IntrinsicController({
    required this.columnCount,
    this.axis = Axis.vertical,
  }) : super(true) {
    _intrinsicHeightCalculator = IntrinsicSizeCalculator(
      itemList: widgetList,
      columnCount: columnCount,
      axis: axis,
    );
  }

  /// Calculate maxHeight in next stack.
  ///
  /// Make sure to call initByRendering before it.
  /// (Or just one stack after it but Synchronous, since this method perform task in next stack)
  ///
  /// ->UI Uses Old Cache Max Height List while New Max Height is being calculated <-
  Future<void> calculateMaxHeight() async {
    if (!super.value) return;
    //Delay to calculate Height in next frame after initRendering is done,
    // else max height is calculated using old data.
    await Future.delayed(Duration.zero);
    _rowsIntrinsicHeight =
        await _intrinsicHeightCalculator.getOverallMaxHeight();
    _refreshCount++;
    super.value = false;
    _beenInitializedOnce=true;
  }
}
