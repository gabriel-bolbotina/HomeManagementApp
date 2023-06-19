import 'dart:core';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homeapp/Pages/FunctionalityPages/addDevicePage.dart';
import 'package:homeapp/Pages/FunctionalityPages/addRoomWidget.dart';
import 'package:homeapp/Services/authentification.dart';

import '../../Services/Animations.dart';
import '../../Services/FirebaseService.dart';
import '../FunctionalityPages/add_functionality.dart';
import '../FunctionalityPages/functionality.dart';
import '../ProfilePages/homeowner_profile.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:homeapp/model/Devices.dart';
import 'package:homeapp/reusables/device_card.dart';
import 'package:homeapp/reusables/doorContainer.dart';
import 'package:homeapp/model/roomModel.dart';

class HomeownerHomePageWidget extends StatefulWidget {
  const HomeownerHomePageWidget({Key? key}) : super(key: key);

  @override
  _HomeownerHomePageWidgetState createState() =>
      _HomeownerHomePageWidgetState();
}

class _HomeownerHomePageWidgetState extends State<HomeownerHomePageWidget> {
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
  bool isImageAvailable = false;
  late  String? image;
  late String imageUrl;
  bool _hasDevices = false;



  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getUsersDeviceList();
    fetchImage();
    await _authentication.getUserName();
    await _authentication.getProfileImage();
    date = getCurrentDate();
    print(isImageAvailable);
  }

  @override
  void initState() {
    fetchImage();
    getUsersDeviceList();
  }



  Future<void> fetchImage() async {
    imageUrl = (await _authentication.getProfileImage())!;
    print(imageUrl);
    setState(() {
      isImageAvailable = imageUrl != null && imageUrl.isNotEmpty;
    });
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
                  background: SizedBox(
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
                                                        const HomeownerProfilePageWidget())), // Image tapped
                                            splashColor: Colors
                                                .white10, // Splash color over image
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: isImageAvailable
                                                      ? NetworkImage(_authentication.urlPath!.trim())
                                                      : Image.asset('assets/images/iconapp.png').image,
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
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 0, 0),
                                    child: RichText(
                                      overflow: TextOverflow.visible,
                                      text: TextSpan(
                                        style:  TextStyle(
                                          fontSize: 25.0,
                                          color: HomeAppTheme.of(context).primaryText ,
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
                                              text: _authentication.userName ?? "",
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
                                                  fontSize: 14,fontFamily: 'Fira Sans',
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
            SliverToBoxAdapter(
              child: RoomNamesWidget(),
            ),
            const SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: DoorStatusContainer(isDoorOpen: true,)))),
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
            SliverToBoxAdapter(
                child: Visibility(
                  visible: !_hasDevices,
                  child: SizedBox(
                      height: 30,
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                            child: RichText(
                              overflow: TextOverflow.visible,
                              text: const TextSpan(
                                text: "You have no devices yet, please add some",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          ))),
                )),
            SliverGrid(
              delegate:
                  SliverChildBuilderDelegate(childCount: _devicesList.length ?? 0,
                      (BuildContext context, int index) {
                        if (_hasDevices == true) {
                          return DeviceCard(_devicesList[index] as Device);


                        } else {
                         return Container(
                           color: Colors.transparent,
                         );
                        }
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
                  backgroundColor: const Color.fromARGB(255, 253, 238, 186), //background color of button
                  foregroundColor: Colors.white, //font color, icon color in button
                  activeBackgroundColor: HomeAppTheme.of(context).primaryColor, //background color when menu is expanded
                  activeForegroundColor: Colors.white,
                  visible: true,
                  closeManually: false,
                  curve: Curves.easeInExpo,
                  overlayColor: Colors.white,
                  overlayOpacity: 0.8, //background layer opacity
                  onOpen: () => BackdropFilter(
                      filter:ImageFilter.blur(sigmaX: 5, sigmaY: 5)),// action when menu opens
                  onClose: () => print('DIAL CLOSED'),
                  childPadding: const EdgeInsets.symmetric(vertical: 0),
                  spacing: 15,
                  spaceBetweenChildren: 15,//action when menu closes

                  elevation: 8.0, //shadow elevation of button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ), //shape of button

                  children: [
                    SpeedDialChild( //speed dial child
                      child: Icon(CupertinoIcons.add_circled_solid),
                      backgroundColor: HomeAppTheme.of(context).secondaryColor,
                      foregroundColor: Colors.white,
                      label: 'Add a smart device',
                      labelBackgroundColor: Colors.white,

                      labelStyle: HomeAppTheme.of(context).subtitle2.override(
                        fontFamily: 'Poppins',
                        color: HomeAppTheme.of(context).secondaryText,
                      ),
                      onTap: () => Navigator.push(
                          context,
                          Animations(
                            page: const AddDevicePageWidget(),
                            animationType: RouteAnimationType.slideFromBottom,
                          )
                      ),

                      onLongPress: () => print('FIRST CHILD LONG PRESS'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SpeedDialChild(
                      child: Icon(CupertinoIcons.app),
                      backgroundColor: HomeAppTheme.of(context).alternate,
                      foregroundColor: Colors.white,
                      label: 'Add a room or zone',
                      labelStyle: HomeAppTheme.of(context).subtitle2.override(
                        fontFamily: 'Poppins',
                        color: HomeAppTheme.of(context).secondaryText,
                      ),
                      onTap: () => Navigator.push(
                          context,
                          Animations(
                            page: const AddRoomPageWidget(),
                            animationType: RouteAnimationType.slideFromBottom,
                          )
                      ),
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

    if (data.size < 0 ) {
      setState(() {
        // Update your state variable accordingly
        _devicesList = [];
        _hasDevices = false;
      });
    }
    else {
      setState(() {
        _devicesList =
            List.from(data.docs.map((doc) => Device.fromSnapshot(doc)));
        _hasDevices = true;
      });
    }
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

  bool isUrlValid(String url) {
    RegExp urlRegex = RegExp(
      r"^(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ;,./?%&=]*)?$",
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegex.hasMatch(url);
  }
}
