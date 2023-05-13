import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:homeapp/Pages/StartingPages/ExpendableContainer.dart';
import 'package:homeapp/Services/authentification.dart';

import '../../Services/FirebaseService.dart';
import '../FunctionalityPages/add_functionality.dart';
import '../FunctionalityPages/functionality.dart';
import '../ProfilePages/homeowner_profile.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/Devices.dart';
import '../model/device_card.dart';
import '../model/doorContainer.dart';
import '../model/roomModel.dart';

class HomeownerHomePageWidget extends StatefulWidget {
  const HomeownerHomePageWidget({Key? key}) : super(key: key);

  @override
  _HomeownerHomePageWidgetState createState() =>
      _HomeownerHomePageWidgetState();
}

class _HomeownerHomePageWidgetState extends State<HomeownerHomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Device _device = Device();
  final Authentication _authentication = Authentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;
  List<Object> _devicesList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Device _devices = Device();
  DateTime now = DateTime.now();
  String? date;
  final bool _pinned = true;
  final bool _snap = false;
  bool _floating = false;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getUsersDeviceList();
    await _authentication.getProfileImage();
    await _authentication.getUserName();
    date = getCurrentDate();
  }

  Future addUserDetails(String firstName, String lastName, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'age': age,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
                automaticallyImplyLeading: false,

              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,


                background: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 70, 0 ,20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // menu icon
                              //Image.asset(
                              //'assets/images/iconapp.png',
                              //height: 30,
                              //color: Colors.grey[800],
                              //),
                          Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          customBorder: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(100)),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const HomeownerProfilePageWidget())), // Image tapped
                          splashColor: Colors
                              .white10, // Splash color over image
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    _authentication.urlPath
                                        ?.trim() ??
                                        ""),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: 65,
                            height: 65,
                          ),
                        ),
                      ])),
                              //const SizedBox(height: 10),
                              // account icon
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                  child: RichText(
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 25.0,
                                        color: Color.fromARGB(210, 10, 10, 10),
                                      ),
                                      children: <TextSpan>[
                                        const TextSpan(
                                            text: "Welcome Home \n",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(text: "$date",

                                          style: const TextStyle(
                                            fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )),



                            ],
                          ))
                    ]),
              )),
          SliverToBoxAdapter(
            child: RoomNamesWidget(),
          ),
          const SliverToBoxAdapter(

              child: DoorStatusContainer(
              isDoorOpen: true,
            ),
          ),

          const SliverToBoxAdapter(

            child: SizedBox(
              height: 20,
            )
            ),

          SliverToBoxAdapter(

              child: SizedBox(
                  height: 20,
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),

                        child: RichText(
                          overflow: TextOverflow.visible,
                          text: const TextSpan(
                            text: "Your Devices",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(232, 10, 10, 10),
                            ),
                          ),
                        ),
                      )))),
          SliverGrid(
            delegate:
                SliverChildBuilderDelegate(childCount: _devicesList.length,
                    (BuildContext context, int index) {
              return DeviceCard(_devicesList[index] as Device);
            }),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20),
          )
        ]),
        floatingActionButton: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
            child: FFButtonWidget(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddFunctionalityTPageWidget())),
              text: '+ Add',
              options: FFButtonOptions(
                width: 100,
                height: 50,
                color: const Color.fromARGB(255, 253, 238, 186),
                textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                    ),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: 15,
              ),
            )));
  }

  void _addDevice() {
    //_device.serialNumber =
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
        print(currentUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  String getCurrentDate() {
    String formatter = DateFormat.yMMMMd('en_US').format(now);
    return formatter;
  }

  Future getUsersDeviceList() async {
    getCurrentUser();
    var uid = currentUser.uid;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("devices")
        .orderBy('device name', descending: true)
        .get();

    setState(() {
      _devicesList =
          List.from(data.docs.map((doc) => Device.fromSnapshot(doc)));
    });
  }
}
