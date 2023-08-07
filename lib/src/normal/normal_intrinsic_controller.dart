part of '../../widget.dart';


class NormalIntrinsicController extends ValueNotifier<bool> {


  NormalIntrinsicController() : super(false);

  double _mainAxisSpacing=0;
  double _crossAxisSpacing=0;
  int _refreshCount=0;
  final _normalSizeCalculator= _NormalSizeCalculator();
  bool get _beenInitializedOnce => _refreshCount>0;
  Axis _axis = Axis.vertical;
  int _crossAxisCount = 0; //0 means not set yet
  List<Widget> _widgetList = [];

  ///Returns unmodifiable list, so you cannot update it.
  ///If you want to update it, you have to use the setter method
  List<Widget> get widgetList => List.unmodifiable(_widgetList);

  ///On Value updated, widgets get rebuild,
  ///and new intrinsic maxAxisExtend are calculated
  ///
  ///Note: If value is already being calculated, then this method will not run
  set widgetList(List<Widget> newValue) {
    if(super.value)return;
    _newValueCache=[...newValue];
    super.value = true;
  }

  List<Widget>? _newValueCache;

  void _onGridviewConstructed({
    required bool preventRebuild,
    required List<Widget> widgets,
    required Axis axis,
    required int crossAxisCount,
    required double mainAxisSpacing,
    required double crossAxisSpacing,
  }) {
    if (!(_beenInitializedOnce && preventRebuild)) {
      _axis = axis;
      _crossAxisCount = crossAxisCount;
      widgetList=widgets;
      _mainAxisSpacing=mainAxisSpacing;
      _crossAxisSpacing=crossAxisSpacing;
    }
  }

  double get totalMainAxisSize {
    final elementSize=_intrinsicMainAxisExtends.fold(
        0.0, (previousValue, element) => previousValue + element);
    double? spacingSize;

    if(_mainAxisSpacing!=0){
      //Below logic is copied from flutter sliver_grid
      final mainAxisCount=((_widgetList.length - 1) ~/ _crossAxisCount) + 1;
      print(mainAxisCount);
      //mainAxisCount-1 because in 2 mainAxisCount there is only one Spacing, in 3 mainAxisCount, there is only two spacing and so on.
      spacingSize=(mainAxisCount-1)*_mainAxisSpacing;
      print(spacingSize);
    }
    return elementSize+(spacingSize??0);
  }


  _NormalDelegate get _delegate=>_NormalDelegate(
    crossAxisCount: _crossAxisCount,
    crossAxisIntrinsicSize: _intrinsicMainAxisExtends,
    totalItems: widgetList.length,
    rebuildCount:_refreshCount,
    crossAxisSpacing: _crossAxisSpacing,
    mainAxisSpacing: _mainAxisSpacing,
  );

  List<double> _intrinsicMainAxisExtends = [];

  /// Have caching, at first when is in initializing phase, do not display gridview.
  /// On second time, even if its initializing, display old gridview
  /// till new gridview data is not loaded.
  bool get canDisplayGridView => _beenInitializedOnce || !super.value;

  Size _parentConstraints=Size.zero;
  Size get parentConstraints=>_parentConstraints;

  Widget renderAndCalculate() {
    if (!super.value) return const SizedBox();
    final toCalculateList=_newValueCache??_widgetList;//Todo: document
    if(toCalculateList.isEmpty || _crossAxisCount<=0){
      return const SizedBox();
    }
    return _normalSizeCalculator.renderAndCalculate(
      _NormalCalculatorInput(
          itemList:toCalculateList,
          crossAxisItemsCount: _crossAxisCount,
          axis: _axis,
          onSuccess: (value) async {
            _parentConstraints=value;
            _intrinsicMainAxisExtends =
                _normalSizeCalculator.intrinsicMainAxisExtends;
            _refreshCount++;
            _widgetList=toCalculateList;
            super.value=false;
          }),
    );
  }



}
