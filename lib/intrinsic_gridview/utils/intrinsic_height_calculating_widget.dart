//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../provider/intrinsic_gridview_controller.dart';
//
// class IntrinsicHeightWidget extends StatelessWidget {
//   const IntrinsicHeightWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Selector<FavoriteDraggableDataProvider,int>(
//       selector: (context,provider)=>provider.intrinsicCalculationRefresh,
//       builder: (context,value,child){
//         //Warning: Listen false because selector is used to refresh,
//         //if listen is set true, optimizing with selector will go in vain.
//         Provider.of<FavoriteDraggableDataProvider>(context,listen: false).calculateMaxHeight();
//         return Provider.of<FavoriteDraggableDataProvider>(context,listen: false).initRendering();
//       },
//     );
//   }
// }
//
//
//
//
