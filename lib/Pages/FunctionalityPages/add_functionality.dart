import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:homeapp/Pages/HomePages/tenant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:developer';

import '../../Services/FirebaseService.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class AddFunctionalityTPageWidget extends StatefulWidget {
  const AddFunctionalityTPageWidget({Key? key}) : super(key: key);

  @override
  _AddFunctionalityTPageWidgetState createState() => _AddFunctionalityTPageWidgetState();
}

class _AddFunctionalityTPageWidgetState  extends State<AddFunctionalityTPageWidget>{
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;
  late final User currentUser;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }


  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/$fileName');
      final uploadTask = await ref.putFile(_photo!);
      final taskSnapshot = await uploadTask;

      final _fileURL = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).collection("devices").doc(deviceNameController.text).update(
        {
          'uploadedImage' : _fileURL
        }
      );
    } catch (e) {
      print('error occured');
    }
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
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

  Future addUserDetails(String deviceName,
      int serialNumber, String type, String brand) async {
    getCurrentUser();
    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection("devices").doc(deviceName).set({
      'device name' : deviceName,
      'serial number': serialNumber,
      'type': type,
      'brand': brand,
      'uploadedImage': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).lineColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).lineColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: CupertinoColors.systemGrey,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TenantHomePageWidget())),
            ),
            centerTitle: false,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: _photo != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _photo!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme
                          .of(context)
                          .secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0x4D101213),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: deviceNameController,
                      validator: (value) =>
                      (value!.isEmpty)
                          ? 'Please enter device name'
                          : null,

                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Your device name ...',
                        labelStyle: FlutterFlowTheme
                            .of(context)
                            .bodyText2,
                        hintText: 'Enter device name...',
                        hintStyle: FlutterFlowTheme
                            .of(context)
                            .bodyText1
                            .override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme
                              .of(context)
                              .secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme
                            .of(context)
                            .secondaryBackground,
                        contentPadding:
                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      ),
                      style: FlutterFlowTheme
                          .of(context)
                          .bodyText1,
                      maxLines: 1,
                    ),
                  ),

                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme
                          .of(context)
                          .secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0x4D101213),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: serialNumberController,
                      validator: (value) =>
                      (value!.isEmpty)
                          ? 'Please enter serial number'
                          : null,

                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Device serial number ...',
                        labelStyle: FlutterFlowTheme
                            .of(context)
                            .bodyText2,
                        hintText: 'Enter device serial number...',
                        hintStyle: FlutterFlowTheme
                            .of(context)
                            .bodyText1
                            .override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme
                              .of(context)
                              .secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme
                            .of(context)
                            .secondaryBackground,
                        contentPadding:
                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      ),
                      style: FlutterFlowTheme
                          .of(context)
                          .bodyText1,
                      maxLines: 1,
                    ),
                  ),

                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme
                          .of(context)
                          .secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0x4D101213),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: typeController,
                      validator: (value) =>
                      (value!.isEmpty)
                          ? 'Please enter device type'
                          : null,

                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Your device type ...',
                        labelStyle: FlutterFlowTheme
                            .of(context)
                            .bodyText2,
                        hintText: 'Enter device type...',
                        hintStyle: FlutterFlowTheme
                            .of(context)
                            .bodyText1
                            .override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme
                              .of(context)
                              .secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme
                            .of(context)
                            .secondaryBackground,
                        contentPadding:
                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      ),
                      style: FlutterFlowTheme
                          .of(context)
                          .bodyText1,
                      maxLines: 1,
                    ),
                  ),

                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme
                          .of(context)
                          .secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0x4D101213),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: brandController,
                      validator: (value) =>
                      (value!.isEmpty)
                          ? 'Please enter device brand'
                          : null,

                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Your device brand ...',
                        labelStyle: FlutterFlowTheme
                            .of(context)
                            .bodyText2,
                        hintText: 'Enter device brand...',
                        hintStyle: FlutterFlowTheme
                            .of(context)
                            .bodyText1
                            .override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme
                              .of(context)
                              .secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme
                            .of(context)
                            .secondaryBackground,
                        contentPadding:
                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      ),
                      style: FlutterFlowTheme
                          .of(context)
                          .bodyText1,
                      maxLines: 1,
                    ),
                  ),

                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          if(deviceNameController.text != null)
                            addUserDetails(deviceNameController.text, int.parse(serialNumberController.text), typeController.text, brandController.text);
                            uploadFile();




                        },
                        text: 'Save Changes',
                        options: FFButtonOptions(
                          width: 130,
                          height: 40,
                          color: FlutterFlowTheme.of(context).primaryBtnText,
                          textStyle: FlutterFlowTheme.of(context).bodyText1,
                          elevation: 1,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                ]
                )

        ));
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

}
