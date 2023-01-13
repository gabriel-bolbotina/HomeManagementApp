import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;
  List<Object> _devicesList = [];
  Device _devices = Device();

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getUsersDeviceList();
    await _authentication.getProfileImage();
  }

  Future addUserDetails (
      String firstName, String lastName, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'age': age,});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Hello, Xulescu',
            style: FlutterFlowTheme.of(context).title2.override(
              fontFamily: 'Poppins',
              color: FlutterFlowTheme.of(context).black600,
            ),
          ),

          centerTitle: false,
          elevation: 0,
        ),
      ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child:InkWell(
                        onTap: () =>Navigator.push(context,
                            new MaterialPageRoute(builder: (context) => HomeownerProfilePageWidget())), // Image tapped
                        splashColor: Colors.white10, // Splash color over image
                        child: Ink.image(
                          fit: BoxFit.cover, // Fixes border issues
                          width: 100,
                          height: 100,
                          image: NetworkImage(_authentication.urlPath?.trim() ??""),
                        ),

                      ),
                    ),

                    SizedBox(
                      width: 500.0,
                      height: 500.0,
                      child:
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20),
                        itemCount: _devicesList.length,
                        itemBuilder: (context, index)
                        {
                          return DeviceCard(_devicesList[index] as Device);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(260, 10, 0, 20),
                      child: FFButtonWidget(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddFunctionalityTPageWidget())),
                        text: '+ Add',
                        options: FFButtonOptions(
                          width: 80,
                          height: 40,
                          color: const Color.fromARGB(255, 253, 238, 186),
                          textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                            fontFamily: 'Poppins',
                            color: Colors.black54,
                          ),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: 20,
                        ),
                      ),
                    )
                  ]
              )
          ),
        )
    );
  }

  void _addDevice()
  {
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

  Future getUsersDeviceList() async{
    getCurrentUser();
    var uid = currentUser.uid;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("devices")
        .orderBy('device name', descending : true)
        .get();

    setState((){
      _devicesList = List.from(data.docs.map((doc) => Device.fromSnapshot(doc)));

    });

  }
}
