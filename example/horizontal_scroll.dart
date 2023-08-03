import 'package:efficient_intrinsic_gridview/efficient_intrinsic_gridview.dart';
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
  final controller=IntrinsicController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
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
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        intrinsicController:controller ,
        children: [
          for (int i = 0; i < 20; i++)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow,
                    width: 5,
                  )),
              child: Row(
                children: [
                  for (int j = 0; j < i + 1; j++)
                    _InnerItem(itemCount: j,index: i,)
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _InnerItem extends StatefulWidget {
  const _InnerItem({
    super.key,
    required this.itemCount,
    required this.index,
  });

  final int itemCount;
  final int index;

  @override
  State<_InnerItem> createState() => _InnerItemState();
}

class _InnerItemState extends State<_InnerItem> {
  double width=20;
  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: (){
        width+=width;
        setState(() {

        });
      },
      child: Container(
        color: Colors.blue,
        margin: const EdgeInsets.only(bottom: 2),
        width: width,
        child: Text(
          "Item ${widget.itemCount + 1}",
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

