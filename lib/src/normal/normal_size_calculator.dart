part of '../../widget.dart';





typedef _CalculateAndAdd = Future<void> Function({
  required List<GlobalKey> crossAxisKeyList,
  required Axis axis,
});

//Todo: Refactor variable to denote both cross axis and main axis scrolling
//Todo: Make this class private, secure it
//Todo: Optimize
///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
///
///
///
//Todo: Make it private
class _NormalCalculatorInput {
  final VoidCallback onSuccess;
  final List<Widget> itemList;
  final int crossAxisItemsCount;
  final Axis axis;

  _NormalCalculatorInput({
    required this.onSuccess,
    required this.itemList,
    required this.crossAxisItemsCount,
    required this.axis,
  });
}

class _NormalSizeCalculator {
  ///At first must call initByRendering and must render that widget somewhere in the widget tree. (That rendered widget is invisible, only used for calculating height)
  _NormalSizeCalculator();

  final List<double> _intrinsicMainAxisExtends = [];

  ///Unmodifiable list, do not try to modify it.
  List<double> get intrinsicMainAxisExtends =>
      List.unmodifiable(_intrinsicMainAxisExtends);

  ///To render the item in the widget tree, so that using keys of that items we can calculate max height.
  ///Items are hidden, since we have used Offstage widget
  Widget renderAndCalculate(_NormalCalculatorInput initInput) {
    _intrinsicMainAxisExtends.clear();
    return Offstage(
      child: _RenderingOffsetWidget(
        initInput: initInput,
        calculateAndAdd: _calculateAndAdd,
      ),
    );
  }

  //Todo: Update document
  ///Must call initByRendering Using latest value of serviceList and render the returned value, before calling this method.
  ///
  /// Returns Overall max height row accordingly, Eg: If there is 2 item in the list, first item is max height of first Row
  /// And Second item is max height of second height and so on..
  Future<void> _calculateAndAdd({
    required List<GlobalKey> crossAxisKeyList,
    required Axis axis,
  }) async {
    double maxMainAxisExtend = 0;
    for (var key in crossAxisKeyList) {
      final size = (key.currentContext?.findRenderObject() as RenderBox).size;
      double currentMainAxisExtend =
          axis == Axis.vertical ? size.height : size.width;
      if (currentMainAxisExtend > maxMainAxisExtend) {
        maxMainAxisExtend = currentMainAxisExtend;
      }
    }
    _intrinsicMainAxisExtends.add(maxMainAxisExtend);
  }
}

class _RenderingOffsetWidget extends StatefulWidget {
  final _NormalCalculatorInput initInput;
  final _CalculateAndAdd calculateAndAdd;

  const _RenderingOffsetWidget({
    super.key,
    required this.initInput,
    required this.calculateAndAdd,
  });

  @override
  State<_RenderingOffsetWidget> createState() => _RenderingOffsetWidgetState();
}

class _RenderingOffsetWidgetState extends State<_RenderingOffsetWidget> {
  Size? parentConstrain;
  int startIndex = 0;
  late int maxCrossAxisCount = widget.initInput.itemList.length;
  late int maxCrossAxisIndex = maxCrossAxisCount - 1;

  List<GlobalKey> _renderingKeyList = [];

  @override
  Widget build(BuildContext context) {
    if (parentConstrain == null) {
      return LayoutBuilder(builder: (context, constrain) {
        Future.delayed(Duration.zero, () {
          parentConstrain = Size(constrain.maxWidth, constrain.maxHeight);
          setState(() {});
        });
        return const SizedBox();
      });
    } else {
      var endIndexExcluding = startIndex + widget.initInput.crossAxisItemsCount;
      if (endIndexExcluding > maxCrossAxisCount) {
        endIndexExcluding = maxCrossAxisCount;
      }
      final renderingList =
          widget.initInput.itemList.sublist(startIndex, endIndexExcluding);
      _renderingKeyList = renderingList.map((e) => GlobalKey()).toList();
      Future.delayed(Duration.zero, () async {
        await widget.calculateAndAdd(
          crossAxisKeyList: _renderingKeyList,
          axis: widget.initInput.axis,
        );
        if (startIndex >= maxCrossAxisIndex) {
          widget.initInput.onSuccess();
        } else {
          startIndex += widget.initInput.crossAxisItemsCount;
          setState(() {});
        }
      });
      return SizedBox(
        height: widget.initInput.axis == Axis.horizontal
            ? parentConstrain!.height
            : null,
        width: widget.initInput.axis == Axis.vertical
            ? parentConstrain!.width
            : null,
        child: Flex(
          direction: widget.initInput.axis == Axis.horizontal
              ? Axis.vertical
              : Axis.horizontal,
          children: [
            for (int i = 0; i < widget.initInput.crossAxisItemsCount; i++)
              Builder(
                builder: (context) {
                  final element = renderingList.elementAtOrNull(i);
                  if (element == null) return const Spacer();
                  return Expanded(
                    key: _renderingKeyList[i],
                    child: element,
                  );
                },
              ),
          ],
        ),
      );
    }
  }
}
