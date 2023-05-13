import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class DoorStatusContainer extends StatelessWidget {
  final bool isDoorOpen;

  const DoorStatusContainer({super.key, required this.isDoorOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsetsDirectional.fromSTEB(40, 20, 40, 20),
      constraints: const BoxConstraints.tightFor(width: 20, height: 120),
      decoration: BoxDecoration(
        color: isDoorOpen ? FlutterFlowTheme.of(context).primaryColor : Colors.red,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            isDoorOpen ? Icons.check_circle : Icons.error,
            size: 50.0,
            color: Colors.black,
          ),
          SizedBox(height: 16.0, width: 39,),
          Text(
            isDoorOpen ? 'Door is Open' : 'Door is Closed',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
