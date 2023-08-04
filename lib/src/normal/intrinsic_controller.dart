part of '../widget.dart';

//Todo: You are doing too risky task when allowing user to change axis and crossAxisCount,
//What if concurrency(Although its Sync), and what about user modifying these value themself.
//Todo: Variable refactor to denote both horizontal and vertical scrolling
class IntrinsicController extends ValueNotifier<bool> {
  var _beenInitializedOnce = false; //Make completer
  Axis _axis = Axis.vertical;
  int _crossAxisCount = 0; //0 means not set yet
  List<Widget> _widgetList = [];

  ///Returns unmodifiable list, so you cannot update it.
  ///If you want to update it, you have to use the setter method
  List<Widget> get widgetList => List.unmodifiable(_widgetList);

  ///On Value updated, widgets get rebuild,
  ///and intrinsic height are recalculated
  set widgetList(List<Widget> newValue) {
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
    if (!(_beenInitializedOnce && preventRebuild)) {
      _axis = axis;
      _crossAxisCount = crossAxisCount;
      widgetList = [...widgets]; //Todo: Should i do it??
    }
  }

  //Todo: Currently excluding gap, why??
  double get getSize => _intrinsicMainAxisExtends.fold(
      0, (previousValue, element) => previousValue + element);

  late IntrinsicSizeCalculator _intrinsicHeightCalculator;

  int _refreshCount = 0;

  IntrinsicDelegate get intrinsicRowGridDelegate => IntrinsicDelegate(
        crossAxisCount: _crossAxisCount,
        crossAxisIntrinsicSize: _intrinsicMainAxisExtends,
        totalItems: widgetList.length,
        crossAxisSizeRefresh: _refreshCount,
      );
  List<double> _intrinsicMainAxisExtends = [];

  bool get isInitialized => _intrinsicMainAxisExtends.isNotEmpty;

  Widget initRendering() {
    if (!super.value) return const SizedBox();
    //Todo: Better blockers, below commented blocker was also good.
    // But previously it didn't worked. Might Future.delayed zero can make it work.
    // if(_widgetList.isEmpty)return const SizedBox();
    // if(_crossAxisCount<=0)return;

    return _intrinsicHeightCalculator.initByRendering(
      itemList: _widgetList,
      crossAxisItemsCount: _crossAxisCount,
        axis: _axis,
        onSuccess: () async {
        _intrinsicMainAxisExtends=_intrinsicHeightCalculator.intrinsicMainAxisExtends;
      _refreshCount++;
      _beenInitializedOnce = true;
      super.value = false;
    });
  }

  IntrinsicController() : super(true) {
    _intrinsicHeightCalculator = IntrinsicSizeCalculator();
  }
}
