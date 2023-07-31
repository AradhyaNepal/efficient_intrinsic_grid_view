import 'package:efficient_intrinsic_gridview/efficient_intrinsic_gridview.dart';
import 'package:efficient_intrinsic_gridview/src/controller_inherited_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: GridviewSolution()));
}

class GridviewSolution extends StatefulWidget {
  const GridviewSolution({super.key});

  @override
  State<GridviewSolution> createState() => _GridviewSolutionState();
}

class _GridviewSolutionState extends State<GridviewSolution> {
  final controller=IntrinsicController(
    columnCount: 3,
    widgetList: [
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
                _InnerItem(j: j,index: i,)
            ],
          ),
        ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              controller.widgetList=controller.widgetList.map((e) => e).toList()..shuffle();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: EfficientIntrinsicGridView(
        controller:controller ,
      ),
    );
  }
}

class _InnerItem extends StatefulWidget {
  const _InnerItem({
    super.key,
    required this.j,
    required this.index,
  });

  final int j;
  final int index;

  @override
  State<_InnerItem> createState() => _InnerItemState();
}

class _InnerItemState extends State<_InnerItem> {
  double height=20;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        height+=height;
        setState(() {

        });
        ControllerInheritedWidget.getController(context).refresh(widget, widget.index);
      },
      child: Container(
        color: Colors.red,
        margin: const EdgeInsets.only(bottom: 2),
        height: height,
        child: Text(
          "Item ${widget.j + 1}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

