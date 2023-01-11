import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:homeapp/Pages/model/device_card.dart';

import '../../Services/FirebaseService.dart';
import '../FunctionalityPages/add_functionality.dart';
import '../FunctionalityPages/functionality.dart';
import '../ProfilePages/homeowner_profile.dart';
import '../ProfilePages/tenant_profile.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/Devices.dart';

class TenantHomePageWidget extends StatefulWidget {
  const TenantHomePageWidget({Key? key}) : super(key: key);

  @override
  _TenantHomePageWidgetState createState() =>
      _TenantHomePageWidgetState();
}

class _TenantHomePageWidgetState extends State<TenantHomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late User currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Object> _devicesList = [];
  Device _devices = Device();

  Future signOut() async {
    return (await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                title: const Text('Are you sure you want to exit the app?',
                  style: TextStyle(color: CupertinoColors.systemGrey,
                    fontFamily: 'Lexend Deca',

                  ),

                  selectionColor: CupertinoColors.systemGrey,
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      FirebaseService service = FirebaseService();
                      await service.signOutFromGoogle();

                      Navigator.pushReplacementNamed(
                          context, 'homescreen');
                    },
                    child: const Text('OK'),
                  ),
                ]
            )
    )
    );
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




          //aici trebuie un pop up cu do you want to exit the app

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(

        children: [ListView.builder(
              itemCount: _devicesList.length,
              itemBuilder: (context, index)
          {
            return DeviceCard(_devicesList[index] as Device);
          }),
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
