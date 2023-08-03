part of '../widget.dart';
//Todo: You are doing too risky task when allowing user to change axis and crossAxisCount,
//What if concurrency(Although its Sync), and what about user modifying these value themself.
//Todo: Variable refactor to denote both horizontal and vertical scrolling
class IntrinsicController extends ValueNotifier<bool> {
  var _beenInitializedOnce=false;//Make completer
  Axis _axis=Axis.vertical;
  int _crossAxisCount=0;//0 means not set yet
  List<Widget> _widgetList = [];

  ///Returns unmodifiable list, so you cannot update it.
  ///If you want to update it, you have to use the setter method
  List<Widget> get widgetList => List.unmodifiable(_widgetList);

  ///On Value updated, widgets get rebuild,
  ///and intrinsic height are recalculated
  set widgetList(List<Widget> newValue) {
    _intrinsicHeightCalculator.axis=_axis;
    _intrinsicHeightCalculator.crossAxisCount=_crossAxisCount;
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
    required Axis axis,
    required int crossAxisCount,
  }) {
    if(!(_beenInitializedOnce && preventRebuild)){
      _axis=axis;
      _crossAxisCount=crossAxisCount;
      //Below must be at last
      widgetList=[...widgets];//Todo: Should i do it??
    }
  }

  //Todo: Currently excluding gap, why??
  double get getSize => _rowsIntrinsicHeight.fold(
      0, (previousValue, element) => previousValue + element);

  late IntrinsicSizeCalculator _intrinsicHeightCalculator;

  int _refreshCount = 0;

  IntrinsicDelegate get intrinsicRowGridDelegate => IntrinsicDelegate(
        crossAxisCount: _crossAxisCount,
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

  IntrinsicController() : super(true) {
    _intrinsicHeightCalculator = IntrinsicSizeCalculator(
      itemList: widgetList,
      crossAxisCount: _crossAxisCount,
      axis: _axis,
    );
  }

  /// Calculate maxHeight in next stack.
  ///
  /// Make sure to call initByRendering before it.
  /// (Or just one stack after it but Synchronous, since this method perform task in next stack)
  ///
  /// ->UI Uses Old Cache Max Height List while New Max Height is being calculated <-
  Future<void> calculateMaxHeight() async {
    if(_crossAxisCount<=0)return;
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
