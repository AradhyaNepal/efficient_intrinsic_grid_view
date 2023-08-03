import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GridViewInput{
      bool reverse;
  ScrollController? controller;
      bool? primary;
  ScrollPhysics? physics;
      ChildIndexGetter? findChildIndexCallback;
      bool addAutomaticKeepAlives;
  bool addRepaintBoundaries;
      bool addSemanticIndexes;
      DragStartBehavior dragStartBehavior;
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
      String? restorationId;
  Clip clipBehavior;
      int? semanticChildCount;


  GridViewInput({
    this.reverse=false,
    this.controller,
    this.primary,
    this.physics,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.dragStartBehavior=DragStartBehavior.start,
    this.keyboardDismissBehavior=ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior=Clip.hardEdge,
    this.semanticChildCount,
});

  //Todo: Research and Add padding
  //Todo: Cache extend available
}