import 'package:flutter/material.dart';
import 'package:homeapp/reusables/roomPage.dart';

import '../../Services/Animations.dart';
import '../Pages/flutter_flow/HomeAppTheme.dart';


class RoomNamesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //height: size.height*0.2,
      padding: EdgeInsets.all(16.0),
      color: HomeAppTheme.of(context).primaryBackground,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
            RoomNameItem(name: 'Living Room', color: HomeAppTheme.of(context).primaryColor,),
            SizedBox(width: 10,),
            RoomNameItem(name: 'Kitchen', color: HomeAppTheme.of(context).secondaryColor,),
            SizedBox(width: 10,),
            RoomNameItem(name: 'Bedroom', color: HomeAppTheme.of(context).primaryColor,),
            SizedBox(width: 10,),
            RoomNameItem(name: 'Bathroom', color: HomeAppTheme.of(context).secondaryColor,),
            SizedBox(width: 10,),
            RoomNameItem(name: 'Garage', color: HomeAppTheme.of(context).primaryColor,),
            const SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }
}

class RoomNameItem extends StatelessWidget {
  final String name;
  final Color color;

  const RoomNameItem({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () => Navigator.push(
          context,
          Animations(
            page: RoomDetailsPage(name: name, color: color,),
            animationType: RouteAnimationType.slideFromRight,
          ),
        ),
      child: Flexible(
        child: Container(
        height: size.height*0.08,
      padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: HomeAppTheme.of(context).secondaryColor.withOpacity(0.5),
        //color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Color(0xFF8E97B9).withOpacity(0.2),
        width: 2),
        //boxShadow:  [BoxShadow(
          //offset: Offset(0, 10),
          //blurRadius: 20,
          //color: Colors.black.withOpacity(0.23),
          //blurStyle: BlurStyle.normal,


        //)
          //  ],
      )
      ,
      child: Align(
      alignment: AlignmentDirectional.center,
      child: Text(
        name,
        style: HomeAppTheme.of(context).subtitle2.override(
          fontFamily: 'Poppins',
          color: Colors.black54,

        ),
      )),
    )));
  }
}
