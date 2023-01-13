

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:io';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../model/User.dart';
import 'package:geocoding/geocoding.dart';


class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  _Address createState() => _Address();
}

class _Address extends State<Address> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  String googleApikey = "AIzaSyD5maQo1oIJr7Kaz6Zm_KGHKNL6FusuTDE";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(27.6602292, 85.308027);
  String location = "Search Location";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User currentUser;
  late String addressMade;


  @override
  void initState() {
    super.initState();
  }

  AddressfromCoord(lat, lon)
  async {

    // converted the lon from string to double


    // Passed the coordinates of latitude and longitude
    var coordinates = await placemarkFromCoordinates(lat,lon);
    var first = coordinates.first;
    return first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme
            .of(context)
            .primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: CupertinoColors.systemGrey,
              ),
              onPressed: () =>
              {Navigator.pushReplacementNamed(context, 'homescreen')},
            ),
            backgroundColor: FlutterFlowTheme
                .of(context)
                .primaryBackground,
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 50,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: FlutterFlowTheme
                                .of(context)
                                .gray600,
                            size: 24,
                          ),
                          onPressed: () async {
                            Navigator.pushReplacementNamed(
                                context, 'homescreen');
                          },
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0.55),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 10, 0, 0),
                          child: Text(
                            'Back',
                            style: FlutterFlowTheme
                                .of(context)
                                .title1
                                .override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme
                                  .of(context)
                                  .gray600,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [],
            centerTitle: true,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(

            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                            child: Text(
                              'Add your address and confirm it on the map',
                              style: FlutterFlowTheme
                                  .of(context)
                                  .subtitle2
                                  .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme
                                    .of(context)
                                    .secondaryText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))
                          ),
                          child: Stack(
                              children: [SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width - 50, // or use fixed size like 200
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height - 500,
                                child:
                                GoogleMap( //Map widget from google_maps_flutter package
                                  zoomGesturesEnabled: true,
                                  //enable Zoom in, out on map
                                  initialCameraPosition: CameraPosition( //innital position in map
                                    target: startLocation, //initial position
                                    zoom: 8.0, //initial zoom level
                                  ),
                                  mapType: MapType.normal,
                                  //map type
                                  onMapCreated: (
                                      controller) { //method called when map is created
                                    setState(() {
                                      mapController = controller;
                                    });
                                  },
                                ),
                              ),


                                //search autoconplete input
                                Positioned(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 50,
                                    // or use fixed size like 200

                                    //search input bar
                                    top: 10,
                                    child: InkWell(
                                        onTap: () async {
                                          var place = await PlacesAutocomplete
                                              .show(
                                              context: context,
                                              apiKey: googleApikey,
                                              mode: Mode.overlay,
                                              types: [],
                                              strictbounds: false,
                                              components: [
                                                Component(
                                                    Component.country, 'ro')
                                              ],
                                              //google_map_webservice package
                                              onError: (err) {
                                                print(err);
                                              }
                                          );

                                          if (place != null) {
                                            setState(() {
                                              location =
                                                  place.description.toString();
                                            });

                                            //form google_maps_webservice package
                                            final plist = GoogleMapsPlaces(
                                              apiKey: googleApikey,
                                              apiHeaders: await const GoogleApiHeaders()
                                                  .getHeaders(),
                                              //from google_api_headers package
                                            );
                                            String placeid = place.placeId ??
                                                "0";
                                            final detail = await plist
                                                .getDetailsByPlaceId(placeid);
                                            final geometry = detail.result
                                                .geometry!;
                                            final lat = geometry.location.lat;
                                            final lang = geometry.location.lng;
                                            var newlatlang = LatLng(lat, lang);


                                            //move map camera to selected place with animation
                                            mapController?.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                    CameraPosition(
                                                        target: newlatlang,
                                                        zoom: 17)));

                                            addUserDetails(AddressfromCoord(lat,lang));
                                            print(AddressfromCoord(lat, lang));
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Card(
                                            child: Container(
                                                padding: EdgeInsets.all(0),
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width - 40,
                                                child: ListTile(
                                                  title: Text(location,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                    color: Colors.black26),),
                                                  trailing: Icon(Icons.search),
                                                  dense: true,
                                                )
                                            ),
                                          ),
                                        )
                                    )
                                )

                              ]
                          )
                      )
                  ),
                  GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [


                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24, 12, 24, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme
                                      .of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Color(0x4D101213),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: streetController,
                                  validator: (value) =>
                                  (value!.isEmpty)
                                      ? 'Please enter the street name'
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Street',
                                    labelStyle: FlutterFlowTheme
                                        .of(context)
                                        .bodyText2,
                                    hintText: 'Please enter your street name...',
                                    hintStyle: FlutterFlowTheme
                                        .of(context)
                                        .bodyText1
                                        .override(
                                      fontFamily: 'Lexend Deca',
                                      color:
                                      FlutterFlowTheme
                                          .of(context)
                                          .secondaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor:
                                    FlutterFlowTheme
                                        .of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                    EdgeInsetsDirectional.fromSTEB(
                                        24, 24, 20, 24),
                                  ),
                                  style: FlutterFlowTheme
                                      .of(context)
                                      .bodyText1,
                                  maxLines: 1,
                                ),
                              ),
                            ),

                            //first name
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24, 14, 24, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme
                                      .of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Color(0x4D101213),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: numberController,
                                  validator: (value) =>
                                  (value!.isEmpty)
                                      ? 'Please enter your street number'
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Street number ...',
                                    labelStyle: FlutterFlowTheme
                                        .of(context)
                                        .bodyText2,
                                    hintText: 'Enter your street number...',
                                    hintStyle: FlutterFlowTheme
                                        .of(context)
                                        .bodyText1
                                        .override(
                                      fontFamily: 'Lexend Deca',
                                      color:
                                      FlutterFlowTheme
                                          .of(context)
                                          .secondaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor:
                                    FlutterFlowTheme
                                        .of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                    EdgeInsetsDirectional.fromSTEB(
                                        24, 24, 20, 24),
                                  ),
                                  style: FlutterFlowTheme
                                      .of(context)
                                      .bodyText1,
                                  maxLines: 1,
                                ),
                              ),
                            ),

                            //last name
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24, 14, 24, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme
                                      .of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Color(0x4D101213),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: zipCodeController,
                                  validator: (value) =>
                                  (value!.isEmpty)
                                      ? 'Please enter your zip code'
                                      : null,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Your zip code ...',
                                    labelStyle: FlutterFlowTheme
                                        .of(context)
                                        .bodyText2,
                                    hintText: 'Enter your zip code...',
                                    hintStyle: FlutterFlowTheme
                                        .of(context)
                                        .bodyText1
                                        .override(
                                      fontFamily: 'Lexend Deca',
                                      color:
                                      FlutterFlowTheme
                                          .of(context)
                                          .secondaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor:
                                    FlutterFlowTheme
                                        .of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                    EdgeInsetsDirectional.fromSTEB(
                                        24, 24, 20, 24),
                                  ),
                                  style: FlutterFlowTheme
                                      .of(context)
                                      .bodyText1,
                                  maxLines: 1,
                                ),
                              ),
                            ),

                            //age
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24, 14, 24, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme
                                      .of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Color(0x4D101213),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: townController,
                                  validator: (value) =>
                                  (value!.isEmpty)
                                      ? 'Please enter your town/city name'
                                      : null,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Your town/city...',
                                    labelStyle: FlutterFlowTheme
                                        .of(context)
                                        .bodyText2,
                                    hintText: 'Enter your town/city...',
                                    hintStyle: FlutterFlowTheme
                                        .of(context)
                                        .bodyText1
                                        .override(
                                      fontFamily: 'Lexend Deca',
                                      color:
                                      FlutterFlowTheme
                                          .of(context)
                                          .secondaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor:
                                    FlutterFlowTheme
                                        .of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                    EdgeInsetsDirectional.fromSTEB(
                                        24, 24, 20, 24),
                                  ),
                                  style: FlutterFlowTheme
                                      .of(context)
                                      .bodyText1,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 24, 0, 20),
                              child: FFButtonWidget(
                                onPressed: () {
                                   addressMade = streetController.text +
                                      ', ' + numberController.text + ', ' +
                                      townController.text;
                                  addUserDetails(addressMade);
                                  addZipCode(zipCodeController.text.trim());
                                   checkAddressAlreadyExists();
                                },
                                text: 'Add address',
                                options: FFButtonOptions(
                                  width: 270,
                                  height: 50,
                                  color: const Color.fromARGB(255, 255, 242,
                                      176),
                                  textStyle:
                                  FlutterFlowTheme
                                      .of(context)
                                      .subtitle2
                                      .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  elevation: 3,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: 20,
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                  )
                ]

            )
        )
    );
  }

  Future addUserDetails(String address) async {
    getCurrentUser();
    await FirebaseFirestore.instance.collection('users')
        .doc(currentUser.uid)
        .update({
      'address': address,
    });
  }

  Future addZipCode(String s) async {
    getCurrentUser();
    await FirebaseFirestore.instance.collection('users')
        .doc(currentUser.uid)
        .update({
      'zip code': s,
    });
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

  Future<void> checkAddressAlreadyExists()
  async {
    getCurrentUser();

    final userRef = FirebaseFirestore.instance.collection("users").doc(currentUser.uid);
    DocumentSnapshot doc = await userRef.get();
    final data = doc.data() as Map<String, dynamic>;
    if(data["role"] == '')
    {
      Navigator.pushNamed(context, "photo_screen");
    }
    else
    {
      if(data["role"] == "homeowner")
      {
        Navigator.pushNamed(context, "homeowner_main");
      }
      if(data["role"] == "tenant")
      {
        Navigator.pushNamed(context, "tenant_main");
      }
      if(data["role"] == "landlord")
      {
        Navigator.pushNamed(context, "landlord_main");
      }
    }
  }






}

class Geocoder {
}
