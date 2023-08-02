import 'package:efficient_intrinsic_gridview/src/normal/controller_inherited_widget.dart';
import 'package:flutter/material.dart';
import '../efficient_intrinsic_gridview.dart';

part 'shrink_wrap/grid_using_column_row.dart';
part 'normal/normal_intrinsic_gridview.dart';
part 'builder/builder_intrinsic_gridview.dart';

///This gridview uses GridView.builder to be efficient, so it will only render widget which user sees, plus some other for buffer.
abstract class EfficientIntrinsicGridView extends StatelessWidget {
  const EfficientIntrinsicGridView._init({super.key});

  factory EfficientIntrinsicGridView({
    Key? key,
    required IntrinsicController controller,
    bool preventOverflow = false,
  }) =>
      _NormalIntrinsicGridView(controller: controller,preventOverflow: preventOverflow,);

  factory EfficientIntrinsicGridView.builder({
    Key? key,
    required IntrinsicController controller,
    bool preventOverflow = false,
  }) =>
      _BuilderIntrinsicGridView(
        key: key,
      );

  //Todo: Comment and test
  factory EfficientIntrinsicGridView.shrinkWrap({
    Key? key,
    required Widget Function(BuildContext, int) itemBuilder,
    required int itemCount,
    int columnCounts = 2,
    double? leftPadding,
    bool alignColumnWise = true, //Todo: Use Axis instead
  }) =>
      _GridUsingColumnRow(
        key: key,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        columnCounts: columnCounts,
        leftPadding: leftPadding,
        alignColumnWise: alignColumnWise,
      );
}



