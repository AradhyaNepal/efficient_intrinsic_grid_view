part of '../widget.dart';

//Todo: You are doing too risky task when allowing user to change axis and crossAxisCount,
//What if concurrency(Although its Sync), and what about user modifying these value themself.
//Todo: Variable refactor to denote both horizontal and vertical scrolling
class IntrinsicController extends ValueNotifier<bool> {
  IntrinsicController() : super(true);

  int refreshCount=0;
  final _intrinsicHeightCalculator= IntrinsicSizeCalculator();
  bool get _beenInitializedOnce => refreshCount>0; //Todo: Think about making it completer, or may be not
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
    super.addListener(() {//Todo: What about removing the listener because in next change too this lister is being called, concurrency
      print("Called12345");



      if (!super.value) {
        _widgetList = [...newValue];
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
      _widgetList=widgets;
      super.value=true;
    }
  }

  //Todo: Currently excluding gap, why??
  double get getSize => _intrinsicMainAxisExtends.fold(
      0, (previousValue, element) => previousValue + element);




  IntrinsicDelegate get intrinsicRowGridDelegate => IntrinsicDelegate(
        crossAxisCount: _crossAxisCount,
        crossAxisIntrinsicSize: _intrinsicMainAxisExtends,
        totalItems: widgetList.length,
        crossAxisSizeRefresh: refreshCount,
      );
  List<double> _intrinsicMainAxisExtends = [];

  /// Have caching, at first when is in initializing phase, do not display gridview.
  /// On second time, even if its initializing, display old gridview
  /// till new gridview data is not loaded.
  bool get canDisplayGridView => _beenInitializedOnce || !super.value;

  Widget renderAndCalculate() {
    if (!super.value) return const SizedBox();
    print("was called");


    if(_widgetList.isEmpty || _crossAxisCount<=0){
      return const SizedBox();
    }
    return _intrinsicHeightCalculator.renderAndCalculate(
      CalculatorInput(
          itemList: _widgetList,
          crossAxisItemsCount: _crossAxisCount,
          axis: _axis,
          onSuccess: () async {
            _intrinsicMainAxisExtends =
                _intrinsicHeightCalculator.intrinsicMainAxisExtends;
            refreshCount++;
            super.value=false;
          }),
    );
  }

}
