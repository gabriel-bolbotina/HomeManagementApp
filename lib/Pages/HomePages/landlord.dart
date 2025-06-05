import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homeapp/Pages/FunctionalityPages/addHousePage.dart';
import 'package:homeapp/Pages/ProfilePages/landlord_profile.dart';
import 'package:homeapp/services/authentication.dart';

import '../../services/Animations.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:homeapp/model/Devices.dart';
import 'package:homeapp/reusables/device_card.dart';

class LandlordHomePageWidget extends StatefulWidget {
  const LandlordHomePageWidget({Key? key}) : super(key: key);

  @override
  _LandlordHomePageWidgetState createState() => _LandlordHomePageWidgetState();
}

class _LandlordHomePageWidgetState extends State<LandlordHomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isRefreshing = false;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: HomeAppTheme.of(context).primaryBackground,
      body: RefreshIndicator(
        onRefresh: refreshDevices,
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: HomeAppTheme.of(context).primaryBackground,
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              expandedHeight: size.height * 0.2,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    height: size.height * 0.2,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 70, 0, 20),
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
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
                                                      const LandlordProfilePageWidget())), // Image tapped
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 0, 0, 0),
                                  child: RichText(
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        color: HomeAppTheme.of(context)
                                            .primaryText,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Welcome Home, \n",
                                          style: TextStyle(
                                              fontFamily: 'Fira Sans',
                                              fontWeight: FontWeight.w600),
                                          //color: FlutterFlowTheme.of(context).primaryText),
                                        ),
                                        TextSpan(
                                            text:
                                                _authentication.userName ?? "",
                                            style: const TextStyle(
                                                fontFamily: 'Fira Sans',
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: " \n",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: "$date",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Fira Sans',
                                              fontWeight: FontWeight.w600,
                                              //fontStyle: FontStyle.italic)
                                            )),
                                      ],
                                    ),
                                  )),
                            ],
                          ))
                    ])),
              )),
          /*SliverToBoxAdapter(
            child: RoomNamesWidget(),
          ),*/
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 20,
          )),
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
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  )))),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 10,
          )),
          SliverGrid(
            delegate:
                SliverChildBuilderDelegate(childCount: _devicesList.length ?? 0,
                    (BuildContext context, int index) {
              if (_devicesList.length != 0)
                return DeviceCard(_devicesList[index] as Device);
              else
                return RichText(
                  overflow: TextOverflow.visible,
                  text: const TextSpan(
                    text: "You don't have any devices yet!",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(232, 10, 10, 10),
                    ),
                  ),
                );
            }),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20),
          )
        ]),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
        child: SpeedDial(
          direction: SpeedDialDirection.up,
          icon: Icons.add, //icon on Floating action button
          activeIcon: Icons.close, //icon when menu is expanded on button
          backgroundColor: const Color.fromARGB(
              255, 253, 238, 186), //background color of button
          foregroundColor: Colors.white, //font color, icon color in button
          activeBackgroundColor: HomeAppTheme.of(context)
              .primaryColor, //background color when menu is expanded
          activeForegroundColor: Colors.white,
          visible: true,
          closeManually: false,
          curve: Curves.easeInExpo,
          overlayColor: Colors.white,
          overlayOpacity: 0.8, //background layer opacity
          onOpen: () => BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 5, sigmaY: 5)), // action when menu opens
          onClose: () => print('DIAL CLOSED'),
          childPadding: const EdgeInsets.symmetric(vertical: 0),
          spacing: 15,
          spaceBetweenChildren: 15, //action when menu closes

          elevation: 8.0, //shadow elevation of button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ), //shape of button

          children: [
            SpeedDialChild(
              //speed dial child
              child: Icon(CupertinoIcons.add_circled_solid),
              backgroundColor: HomeAppTheme.of(context).secondaryColor,
              foregroundColor: Colors.white,
              label: 'Generate QR code for tenants',
              labelBackgroundColor: Colors.white,

              labelStyle: HomeAppTheme.of(context).subtitle2.override(
                    fontFamily: 'Poppins',
                    color: HomeAppTheme.of(context).secondaryText,
                  ),
              onTap: () => Navigator.push(
                  context,
                  Animations(
                    page: const AddHousePage(),
                    animationType: RouteAnimationType.slideFromBottom,
                  )),

              onLongPress: () => print('FIRST CHILD LONG PRESS'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SpeedDialChild(
              child: Icon(CupertinoIcons.app),
              backgroundColor: HomeAppTheme.of(context).alternate,
              foregroundColor: Colors.white,
              label: 'Add a house',
              labelStyle: HomeAppTheme.of(context).subtitle2.override(
                    fontFamily: 'Poppins',
                    color: HomeAppTheme.of(context).secondaryText,
                  ),
              onTap: () => print('SECOND CHILD'),
              onLongPress: () => print('SECOND CHILD LONG PRESS'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            //add more menu item children here
          ],
        ),
      ),
    );
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
    print(_devicesList);
  }

  Future<void> refreshDevices() async {
    setState(() {
      isRefreshing = true;
    });

    await getUsersDeviceList();

    setState(() {
      isRefreshing = false;
    });
  }
}
