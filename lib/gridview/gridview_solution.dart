import 'package:flutter/material.dart';
import 'package:intrinsic_gridview/intrinsic_gridview/intrinsic_gridview.dart';
import 'package:intrinsic_gridview/intrinsic_gridview/utils/intrinsic_gridview_controller.dart';

class GridviewSolution extends StatelessWidget {
  const GridviewSolution({super.key});

  @override
  Widget build(BuildContext context) {
    final itemList = <Widget>[
      for (int i = 0; i < 20; i++)
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.blue,
            width: 5,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int j = 0; j < i + 1; j++)
                Container(
                  color: Colors.red,
                  margin: const EdgeInsets.only(bottom: 2),
                  height: 20,
                  child: Text(
                    "Item ${j + 1}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ],
          ),
        ),
    ];
    return Scaffold(
      body: IntrinsicGridView(
        controller: IntrinsicGridviewController(
          columnCount: 3,
          widgetList: itemList,
        ),
      ),
    );
  }
}
