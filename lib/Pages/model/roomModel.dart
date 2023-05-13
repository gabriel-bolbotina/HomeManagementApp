import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class RoomNamesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: FlutterFlowTheme.of(context).primaryBackground,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
            RoomNameItem(name: 'Living Room', color: FlutterFlowTheme.of(context).primaryColor,),
            SizedBox(width: 10,),
            RoomNameItem(name: 'Kitchen', color: FlutterFlowTheme.of(context).secondaryColor,),
            SizedBox(width: 10,),
            RoomNameItem(name: 'Bedroom', color: FlutterFlowTheme.of(context).primaryColor,),
            SizedBox(width: 10,),
            RoomNameItem(name: 'Bathroom', color: FlutterFlowTheme.of(context).secondaryColor,),
            SizedBox(width: 10,),
            RoomNameItem(name: 'Garage', color: FlutterFlowTheme.of(context).primaryColor,),
            SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }
}

class RoomNameItem extends StatelessWidget {
  final String name;
  final Color color;

  RoomNameItem({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
    // Handle the click event here
    print('Clicked: $name');
    },
      child: Container(
      padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      )
      ,
      child: Text(
        name,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}
