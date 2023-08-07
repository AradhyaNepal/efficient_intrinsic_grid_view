part of '../../widget.dart';

//Todo: You are doing too risky task when allowing user to change axis and crossAxisCount,
//What if concurrency(Although its Sync), and what about user modifying these value themself.
//Todo: Variable refactor to denote both horizontal and vertical scrolling
class BuilderIntrinsicController extends ValueNotifier<int> {
  BuilderIntrinsicController() : super(0);

  final _intrinsicHeightCalculator = BuilderSizeCalculator();
  Axis _axis = Axis.vertical;
  int _crossAxisCount = 0; //0 means not set yet
  List<Widget> _widgetList = [];

  bool _canDisplayGridView = false;

  /// Have caching, at first when is in calculation phase, do not display gridview.
  /// On second time, even if its calculating new data, display old gridview
  /// till new gridview data is not loaded.
  bool get canDisplayGridView => _canDisplayGridView;

  ///Returns unmodifiable list, so you cannot update it.
  ///If you want to update it, you have to use the setter method
  List<Widget> get widgetList => List.unmodifiable(_widgetList);

  ///On Value updated, widgets get rebuild,
  ///and intrinsic height are recalculated
  set widgetList(List<Widget> newValue) {
    _newValueCache = [
      ...newValue
    ]; //Todo: Three dot performance vs unmodifiable
    value = value++;
  }

  List<Widget>? _newValueCache;

  //Todo: Make it work, and logic verify
  void _onGridviewConstructed({
    required bool preventRebuild,
    required List<Widget> widgets,
    required Axis axis,
    required int crossAxisCount,
  }) {
    if (!(preventRebuild)) {
      _axis = axis;
      _crossAxisCount = crossAxisCount;
      widgetList = widgets;
    }
  }

  final _currentIndexNotifier = ValueNotifier(0);

  //Todo: Currently excluding gap, why??
  double get getSize => _intrinsicMainAxisExtends.fold(
      0, (previousValue, element) => previousValue + element);

  Widget renderOrCalculateSize(int index, Widget Function() childBuilder) {
    _currentIndexNotifier.value=index;
    return childBuilder();
  }

  BuilderDelegate get _intrinsicRowGridDelegate => BuilderDelegate(
        crossAxisCount: _crossAxisCount,
        crossAxisIntrinsicSize: _intrinsicMainAxisExtends,
        totalItems: widgetList.length,
        crossAxisSizeRefresh: value,
      );
  List<double> _intrinsicMainAxisExtends = [];

  ///Needs to render the widget returned by this calculator to make it work.
  ///And refresh must not rerun this method
  //Todo: Whether refresh should not rerun this method or maybe it can rerun??
  Widget _lazySizeCalculator() {
    final toCalculateList = _newValueCache ?? _widgetList; //Todo: document
    if (toCalculateList.isEmpty || _crossAxisCount <= 0) {
      return const SizedBox();
    }
    return _intrinsicHeightCalculator.lazySizeCalculator(
      BuilderCalculatorInput(
          currentIndexNotifier: _currentIndexNotifier,
          itemList: toCalculateList,
          crossAxisItemsCount: _crossAxisCount,
          axis: _axis,
          onSuccess: () async {
            _intrinsicMainAxisExtends =
                _intrinsicHeightCalculator.intrinsicMainAxisExtends;
            _widgetList = toCalculateList;
            _canDisplayGridView = true;
          }),
    );
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }
}
