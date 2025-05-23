

import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';

import '../EditPages/homeowner_edit.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:homeapp/model/User.dart';


class Address extends StatefulWidget {

  final bool fromRegister;

  const Address({required this.fromRegister});


  @override
  _Address createState() => _Address();
}

class _Address extends State<Address> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final Completer<GoogleMapController> _cntr= Completer();
  String googleApikey = "AIzaSyD5maQo1oIJr7Kaz6Zm_KGHKNL6FusuTDE";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(37.2941, -121.7992);
  late Placemark locationName;
  //Location location = Location();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User currentUser;
  late String addressMade;
  String? _currentAddress;
  late Position _currentPosition;
  bool mapToggle = false;
  bool loading = false;

  String strLatLong = "";

  String strAlamat = 'Mencari lokasi...';
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );


  @override
  initState()  {
    super.initState();
    Future.delayed(Duration.zero,()async{
      _currentPosition = await _getGeoLocationPosition();
      locationName = await getAddressFromLongLat(_currentPosition);

    });
    mapToggle = false;


  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    //permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // //getAddress
  Future<Placemark> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);

    Placemark place = placemarks[0];
    setState(() {
      strAlamat = '${place.street} ${place.subLocality} ${place.locality}${place.postalCode} ${place.country}';
    });

    return place;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    //mapController.setMapStyle(mapTheme);
    _cntr.complete(mapController);
    //_getCurrentPosition();
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
          print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
        });{
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target:
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude), zoom: 20),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.fromRegister) {
      return Scaffold(
          key: scaffoldKey,
          backgroundColor: HomeAppTheme
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
              backgroundColor: HomeAppTheme
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
                              color: HomeAppTheme
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4, 10, 0, 0),
                            child: Text(
                              'Back',
                              style: HomeAppTheme
                                  .of(context)
                                  .title1
                                  .override(
                                fontFamily: 'Poppins',
                                color: HomeAppTheme
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8, 8, 8, 8),
                              child: Text(
                                'Add your address and confirm it on the map',
                                style: HomeAppTheme
                                    .of(context)
                                    .subtitle2
                                    .override(
                                  fontFamily: 'Poppins',
                                  color: HomeAppTheme
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
                                  /*GoogleMap( //Map widget from google_maps_flutter package
                                    zoomGesturesEnabled: true,
                                    //enable Zoom in, out on map
                                    initialCameraPosition: CameraPosition( //innital position in map
                                      target: startLocation, //initial position
                                      zoom: 8.0, //initial zoom level
                                    ),
                                    mapType: MapType.normal,
                                    //map type
                                    onMapCreated: _onMapCreated
                                ),*/

                                  mapToggle
                                      ? GoogleMap(
                                      onMapCreated: _onMapCreated,
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              _currentPosition.latitude,
                                              _currentPosition.longitude),
                                          zoom: 10.0))
                                      : Center(
                                      child: Text(
                                        'Loading.. Please wait..',
                                        style: TextStyle(fontSize: 20.0),
                                      )
                                  ),),


                                  //search autoconplete input


                                ]
                            )
                        )
                    ),
                    GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              const SizedBox(height: 32),

                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });

                                  Position position = await _getGeoLocationPosition();
                                  setState(() {
                                    loading = false;
                                    strLatLong =
                                    '${position.latitude}, ${position
                                        .longitude}';
                                  });

                                  locationName = await getAddressFromLongLat(
                                      position);
                                  mapToggle = true;
                                },
                                child: const Text("Get Current Location"),
                              ),


                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 12, 24, 0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: HomeAppTheme
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
                                        : locationName.street,
                                    decoration: mapToggle
                                        ? InputDecoration(
                                      labelText: locationName.street as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Please enter your street name...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    )
                                        : InputDecoration(
                                      labelText: "Please enter your Street name and number",
                                      //locationName.street as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Please enter your street name...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    ),
                                    style: HomeAppTheme
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
                                    color: HomeAppTheme
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
                                        : locationName.postalCode,
                                    obscureText: false,
                                    decoration: mapToggle
                                        ? InputDecoration(
                                      labelText: locationName
                                          .postalCode as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Enter your zip code...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    )
                                        : InputDecoration(
                                      labelText: "Your Postal Code",
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Enter your zip code...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    )

                                    ,
                                    style: HomeAppTheme
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
                                    color: HomeAppTheme
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
                                    decoration: mapToggle
                                        ? InputDecoration(
                                      labelText: locationName
                                          .locality as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Enter your town/city...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    )
                                        : InputDecoration(
                                      labelText: " Please enter your Town/city",
                                      //locationName.locality as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Enter your town/city...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    ),
                                    style: HomeAppTheme
                                        .of(context)
                                        .bodyText1,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 24, 0, 20),
                                child: HomeAppButtonWidget(
                                  onPressed: () {
                                    addressMade = locationName.street! + ', ' +
                                        locationName.locality!;
                                    print(addressMade);
                                    addUserDetails(addressMade);
                                    addZipCode(locationName.postalCode!);

                                    checkAddressAlreadyExists();
                                  },
                                  text: 'Add address',
                                  options: HomeAppButtonOptions(
                                    width: 270,
                                    height: 50,
                                    color: const Color.fromARGB(255, 255, 242,
                                        176),
                                    textStyle:
                                    HomeAppTheme
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
    else {

      return Scaffold(
          key: scaffoldKey,
          backgroundColor: HomeAppTheme
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
              backgroundColor: HomeAppTheme
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
                              color: HomeAppTheme
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4, 10, 0, 0),
                            child: Text(
                              'Back',
                              style: HomeAppTheme
                                  .of(context)
                                  .title1
                                  .override(
                                fontFamily: 'Poppins',
                                color: HomeAppTheme
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8, 8, 8, 8),
                              child: Text(
                                'Add your address and confirm it on the map',
                                style: HomeAppTheme
                                    .of(context)
                                    .subtitle2
                                    .override(
                                  fontFamily: 'Poppins',
                                  color: HomeAppTheme
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
                                  /*GoogleMap( //Map widget from google_maps_flutter package
                                    zoomGesturesEnabled: true,
                                    //enable Zoom in, out on map
                                    initialCameraPosition: CameraPosition( //innital position in map
                                      target: startLocation, //initial position
                                      zoom: 8.0, //initial zoom level
                                    ),
                                    mapType: MapType.normal,
                                    //map type
                                    onMapCreated: _onMapCreated
                                ),*/

                                  mapToggle
                                      ? GoogleMap(
                                      onMapCreated: _onMapCreated,
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              _currentPosition.latitude,
                                              _currentPosition.longitude),
                                          zoom: 10.0))
                                      : Center(
                                      child: Text(
                                        'Loading.. Please wait..',
                                        style: TextStyle(fontSize: 20.0),
                                      )
                                  ),),


                                  //search autoconplete input


                                ]
                            )
                        )
                    ),
                    GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              const SizedBox(height: 32),

                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });

                                  Position position = await _getGeoLocationPosition();
                                  setState(() {
                                    loading = false;
                                    strLatLong =
                                    '${position.latitude}, ${position
                                        .longitude}';
                                  });

                                  locationName = await getAddressFromLongLat(
                                      position);
                                  mapToggle = true;
                                },
                                child: const Text("Get Current Location"),
                              ),


                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 12, 24, 0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: HomeAppTheme
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
                                        : locationName.street,
                                    decoration: mapToggle
                                        ? InputDecoration(
                                      labelText: locationName.street as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Please enter your street name...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    )
                                        : InputDecoration(
                                      labelText: "Please enter your Street name and number",
                                      //locationName.street as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Please enter your street name...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    ),
                                    style: HomeAppTheme
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
                                    color: HomeAppTheme
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
                                        : locationName.postalCode,
                                    obscureText: false,
                                    decoration: mapToggle
                                        ? InputDecoration(
                                      labelText: locationName
                                          .postalCode as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Enter your zip code...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    )
                                        : InputDecoration(
                                      labelText: "Your Postal Code",
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Enter your zip code...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    )

                                    ,
                                    style: HomeAppTheme
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
                                    color: HomeAppTheme
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
                                    decoration: mapToggle
                                        ? InputDecoration(
                                      labelText: locationName
                                          .locality as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Enter your town/city...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    )
                                        : InputDecoration(
                                      labelText: " Please enter your Town/city",
                                      //locationName.locality as String,
                                      labelStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText2,
                                      hintText: 'Enter your town/city...',
                                      hintStyle: HomeAppTheme
                                          .of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Lexend Deca',
                                        color:
                                        HomeAppTheme
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
                                      HomeAppTheme
                                          .of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          24, 24, 20, 24),
                                    ),
                                    style: HomeAppTheme
                                        .of(context)
                                        .bodyText1,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 24, 0, 20),
                                child: HomeAppButtonWidget(
                                  onPressed: () {
                                    addressMade = locationName.street! + ', ' +
                                        locationName.locality!;
                                    print(addressMade);
                                    updateAddress(addressMade);
                                    //addZipCode(locationName.postalCode!);
                                    Navigator.push(context,
                                        new MaterialPageRoute(builder: (context) => HomeownerEditPageWidget()));

                                  },
                                  text: 'Add address',
                                  options: HomeAppButtonOptions(
                                    width: 270,
                                    height: 50,
                                    color: const Color.fromARGB(255, 255, 242,
                                        176),
                                    textStyle:
                                    HomeAppTheme
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
    return Container();
  }

  Future addUserDetails(String address) async {
    getCurrentUser();
    await FirebaseFirestore.instance.collection('users')
        .doc(currentUser.uid)
        .update({
      'address': address,
    });
  }

  void updateAddress(String s) async {
    getCurrentUser();
    await _firestore.collection('users').doc(currentUser.uid).update({
      'address': s,
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
      Navigator.pushNamed(this.context, "photo_screen");
    }
    else
    {
      if(data["role"] == "homeowner")
      {
        Navigator.pushNamed(this.context, "homeowner_main");
      }
      if(data["role"] == "tenant")
      {
        Navigator.pushNamed(this.context, "tenant_main");
      }
      if(data["role"] == "landlord")
      {
        Navigator.pushNamed(this.context, "landlord_main");
      }
    }
  }











}





class Geocoder {
}
