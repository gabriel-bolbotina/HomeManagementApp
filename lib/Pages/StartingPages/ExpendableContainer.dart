import 'package:flutter/material.dart';

class ExpandableContainer extends StatefulWidget {
  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpanded,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: isExpanded ? 300 : 100, // Change the height as needed
        color: Colors.blue,
        child: isExpanded ? buildGridView() : Container(),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2, // Change the number of columns as needed
      children: List.generate(6, (index) {
        return Container(
          color: Colors.green,
          margin: EdgeInsets.all(8),
          child: Center(
            child: Text(
              'Item $index',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }),
    );
  }
}

class ExpandableContainerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expandable Container'),
      ),
      body: Center(
        child: ExpandableContainer(),
      ),
    );
  }
}


