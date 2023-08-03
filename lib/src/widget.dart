import 'package:efficient_intrinsic_gridview/src/normal/controller_inherited_widget.dart';
import 'package:flutter/material.dart';
import '../efficient_intrinsic_gridview.dart';

part 'shrink_wrap/grid_using_column_row.dart';

part 'normal/normal_intrinsic_gridview.dart';

part 'builder/builder_intrinsic_gridview.dart';

/// A GridView which allowed every crossAxis to have its own intrinsic size,
/// its own intrinsic height for vertical scrolling or its own intrinsic width for horizontal scrolling.
/// ### What is Intrinsic?
/// Lets say, you are using GridView with vertical scrolling, in this case crossAxis means every Row.
/// Lets assume that every Row's element have its own different height, and while rendering a specific Row,
/// you want to set height of the maximum element of that specific Row,
/// that's called setting intrinsic size of every crossAxis of a [GridView].
///
/// By default [GridView] does not allows this, in [GridView] you have to set a one fixed mainAxisExtent
/// or internally [GridView] will automatically calculates one mainAxisExtent for every crossAxis.
/// Lets say A crossAxis have max size X and B crossAxis have max size Y.
/// In [GridView] you are forced to use only one mainAxisExtent, say Y.
/// So even A crossAxis have to use Y mainAxisExtent, leaving unnecessary white spaces.
///
/// And that's how I come up with an idea of creating this package!.
/// In this package we have multiple mainAxisExtent as per every crossAxis's elements max size.
///
/// ### But why there is Efficient word in my package??
/// Because it is efficient.
///
/// This Intrinsic name was inspired to be from [IntrinsicHeight] and [IntrinsicWidth] widget provided by Flutter framework.
/// To demonstrate what inefficiency is, I have also created [EfficientIntrinsicGridView.shrinkWrap],
/// which is made from combination of [IntrinsicHeight] and [IntrinsicWidth]
/// on scrollable [Row] and [Column] to render the gridview.
/// I have named it shrinkWrap, because most of new developer learns about shrinkWrap
/// when flutter is throwing hasInfinite size error on Scrolling item.
/// This widget prevents that error.
/// (I personally hate using shrinkWrap true, so either set use proper sizing of the elements or
/// from controller you can access total calculated mainAxisSize/mainAxisExtent of the [GridView],
/// or my favorite way is to use [CustomScrollView])
///
/// Lets say there are 1000 items on a [GridView], [IntrinsicHeight] and [IntrinsicWidth] are already an expensive widget,
/// and when you are using [EfficientIntrinsicGridView.shrinkWrap] you are rendering all the expensive 1000 widgets at once.
/// Huge memory will be used by the app, sometimes your app can even crash
/// if your memory consumption is higher than RAM memory available.
/// That's why don't use [EfficientIntrinsicGridView.shrinkWrap], its inefficient.
///
/// Use [EfficientIntrinsicGridView] or [EfficientIntrinsicGridView.builder] instead.
///
/// Both have there own efficient algorithm to calculate intrinsic mainAxisSize of crossAxis items
/// (without using expensive [IntrinsicHeight] and [IntrinsicWidth]).
/// And after calculating the size, custom [SliverGridDelegate]
/// renders only the element which is visible to the user, plus one extra buffer.
///
/// And that's why its efficient!

abstract class EfficientIntrinsicGridView extends StatelessWidget {
  const EfficientIntrinsicGridView._init({super.key});

  factory EfficientIntrinsicGridView({
    Key? key,
    required IntrinsicController controller,
    bool preventOverflow = false,
  }) =>
      _NormalIntrinsicGridView(
        controller: controller,
        preventOverflow: preventOverflow,
      );

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
