import 'package:efficient_intrinsic_gridview/efficient_intrinsic_gridview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: VerticalGridViewExample()));
}

class VerticalGridViewExample extends StatefulWidget {
  const VerticalGridViewExample({super.key});

  @override
  State<VerticalGridViewExample> createState() => _VerticalGridViewExampleState();
}

class _VerticalGridViewExampleState extends State<VerticalGridViewExample> {
  final controller = IntrinsicController();

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
              controller.widgetList =
              controller.widgetList.map((e) => e).toList()..shuffle();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: EfficientIntrinsicGridView(
        preventOverflow: false,
        preventRebuild: true,
        intrinsicController: controller,
        crossAxisCount: 2,
        children: [
          for (int i = 0; i < 1000; i++)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 5,
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int j = 0; j < (i%10)+1; j++)
                    _VerticalItem(
                      itemCount: j,
                      index: i,
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _VerticalItem extends StatefulWidget {
  const _VerticalItem({
    super.key,
    required this.itemCount,
    required this.index,
  });

  final int itemCount;
  final int index;

  @override
  State<_VerticalItem> createState() => _VerticalItemState();
}

class _VerticalItemState extends State<_VerticalItem> {
  double height = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        height += height;
        setState(() {});
      },
      child: Container(
        color: Colors.red,
        margin: const EdgeInsets.only(bottom: 2),
        height: height,
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


class HorizontalGridViewExample extends StatefulWidget {
  const HorizontalGridViewExample({super.key});
  @override
  State<HorizontalGridViewExample> createState() => _HorizontalGridViewExampleState();
}

class _HorizontalGridViewExampleState extends State<HorizontalGridViewExample> {
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
        preventRebuild: false,
        crossAxisCount: 3,
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
                    _HorizontalItem(itemCount: j,index: i,)
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HorizontalItem extends StatefulWidget {
  const _HorizontalItem({
    super.key,
    required this.itemCount,
    required this.index,
  });

  final int itemCount;
  final int index;

  @override
  State<_HorizontalItem> createState() => _HorizontalItemState();
}

class _HorizontalItemState extends State<_HorizontalItem> {
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

