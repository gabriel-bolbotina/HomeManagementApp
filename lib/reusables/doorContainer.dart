import 'package:flutter/material.dart';

import '../Pages/flutter_flow/HomeAppTheme.dart';


class DoorStatusContainer extends StatelessWidget {
  final bool isDoorOpen;

  const DoorStatusContainer({super.key, required this.isDoorOpen});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
          width: size.width * 0.4,
          height: size.height * 0.13,
        decoration: BoxDecoration(
        color: isDoorOpen ? HomeAppTheme.of(context).primaryColor.withOpacity(0.25) : Colors.red,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            isDoorOpen ? Icons.check_circle : Icons.error,
            size: 30.0,
            color: Colors.black54,
          ),
          SizedBox(height: 16.0, width: 39,),
          Text(
            isDoorOpen ? 'Door is Open' : 'Door is Closed',
            style: HomeAppTheme.of(context).subtitle2.override(
              fontFamily: 'Poppins',
              color: Colors.black54,

            ),
          ),
        ],
      )
    );
  }
}
