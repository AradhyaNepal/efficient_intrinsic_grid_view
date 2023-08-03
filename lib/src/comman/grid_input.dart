import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GridViewInput {
  /// {@macro flutter.widgets.scroll_view.reverse}
  bool reverse;

  /// {@macro flutter.widgets.scroll_view.controller}
  ScrollController? controller;

  /// {@macro flutter.widgets.scroll_view.primary}
  bool? primary;

  /// {@macro flutter.widgets.scroll_view.physics}
  ScrollPhysics? physics;

  /// @macro flutter.widgets.PageView.findChildIndexCallback
  ChildIndexGetter? findChildIndexCallback;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addAutomaticKeepAlives}
  bool addAutomaticKeepAlives;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addRepaintBoundaries}
  bool addRepaintBoundaries;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addSemanticIndexes}
  bool addSemanticIndexes;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.scroll_view.keyboardDismissBehavior}
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  String? restorationId;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  Clip clipBehavior;

  //Below docs is copied from Flutter Official Documentation
  /// The number of children that will contribute semantic information.
  ///
  /// The value will be null if the number of children is unknown or unbounded.
  ///
  /// Some subtypes of [ScrollView] can infer this value automatically. For
  /// example [ListView] will use the number of widgets in the child list,
  /// while the [ListView.separated] constructor will use half that amount.
  ///
  /// For [CustomScrollView] and other types which do not receive a builder
  /// or list of widgets, the child count must be explicitly provided.
  ///
  /// See also:
  ///
  ///  * [CustomScrollView], for an explanation of scroll semantics.
  ///  * [SemanticsConfiguration.scrollChildCount], the corresponding semantics property.
  int? semanticChildCount;

  GridViewInput({
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.semanticChildCount,
  });

//Todo: Research and Add padding
//Todo: Cache extend available
}
