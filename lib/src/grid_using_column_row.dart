part of "widget.dart";


class _GridUsingColumnRow extends EfficientIntrinsicGridView  {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int columnCounts;
  final double? leftPadding;
  final bool alignColumnWise;

  ///THIS NESTED LOOP WIDGET IS BETTER THAN GRIDVIEW BECAUSE
  ///WE CAN USE "IntrinsicHeight Widget" FOR EACH ROW
  ///This class will be deprecated once Custom GridView is made which auto calculate height,
  ///because this way may crash app in large data
  const _GridUsingColumnRow({
    required this.itemBuilder,
    required this.itemCount,
    required this.columnCounts,
    required this.leftPadding,
    required this.alignColumnWise,
    Key? key,
  }) : super._init(key: key);

  @override
  Widget build(BuildContext context) {
    if (alignColumnWise) {
      return _ColumnWise(
        itemCount: itemCount,
        columnCounts: columnCounts,
        itemBuilder: itemBuilder,
        leftPadding: leftPadding,
      );
    } else {
      return _RowWise(
        columnCounts: columnCounts,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        leftPadding: leftPadding,
      );
    }
  }
}


class _ColumnWise extends StatelessWidget {
  const _ColumnWise({
    required this.itemCount,
    required this.columnCounts,
    required this.itemBuilder,
    required this.leftPadding,
  });

  final int itemCount;
  final int columnCounts;
  final IndexedWidgetBuilder itemBuilder;
  final double? leftPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int firstRowItem = 0;
            firstRowItem < itemCount;
            firstRowItem = firstRowItem + columnCounts)
          Row(
            children: [
              for (int column = 0; column < columnCounts; column++) ...[
                Expanded(
                  child: Builder(builder: (context) {
                    int index = firstRowItem + column;
                    try {
                      return itemBuilder(context, index);
                    } catch (e) {
                      return const SizedBox();
                    }
                  }),
                ),
                columnCounts > 0 && column % columnCounts == 0
                    ? SizedBox(
                        width: leftPadding ?? 15,
                      )
                    : const SizedBox(),
              ],
            ],
          ),
      ],
    );
  }
}



class _RowWise extends StatelessWidget {
  const _RowWise({
    required this.columnCounts,
    required this.itemCount,
    required this.itemBuilder,
    required this.leftPadding,
  });

  final int columnCounts;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? leftPadding;

  @override
  Widget build(BuildContext context) {
    int rowCounts=_getRowCount(itemCount, columnCounts);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int column = 0; column < columnCounts; column++)
          Expanded(
            child: Column(
              children: [
                for (int row=0;row<rowCounts;row++) ...[
                  Builder(builder: (context) {
                    int index = column + row*columnCounts;
                    try {
                      return itemBuilder(context, index);
                    } catch (e) {
                      return const SizedBox();
                    }
                  }),
                ],
              ],
            ),
          ),
      ],
    );
  }
  int _getRowCount(int itemCount,int columnCounts){
    return (itemCount~/columnCounts)+((itemCount%columnCounts)==0?0:1);
  }
}

