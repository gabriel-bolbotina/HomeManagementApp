import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:homeapp/Services/authentification.dart';

import '../../Services/FirebaseService.dart';
import '../HomePages/homeowner.dart';
import '../NotificationPages/homeowner_notification.dart';
import '../ProfilePages/homeowner_profile.dart';
import '../ProfilePages/landlord_profile.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandlordEditPageWidget extends StatefulWidget {
  const LandlordEditPageWidget({Key? key}) : super(key: key);

  @override
  _LandlordEditPageWidgetState createState() => _LandlordEditPageWidgetState();
}

class _LandlordEditPageWidgetState extends State<LandlordEditPageWidget> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;
  late final User currentUser;
  late Authentication _authentication;
  bool isImageAvailable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    _authentication = Authentication();
    if (_authentication.getDataImage() != "") {
      isImageAvailable = true;
      print(_authentication.getDataImage());
    } else {
      isImageAvailable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: HomeAppTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: HomeAppTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: CupertinoColors.systemGrey,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LandlordProfilePageWidget())),
            ),
            centerTitle: false,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Container(
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.topRight,
                child: Visibility(
                    visible: isImageAvailable,
                    child:
                        Image.network(_authentication.getDataImage() ?? ''))),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Container(
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.topRight,
                child: Visibility(
                    visible: !isImageAvailable,
                    child: CupertinoActivityIndicator())),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeAppButtonWidget(
                  onPressed: () async {},
                  text: 'Change Photo',
                  options: HomeAppButtonOptions(
                    width: 130,
                    height: 40,
                    color: HomeAppTheme.of(context).primaryBtnText,
                    textStyle: HomeAppTheme.of(context).bodyText1,
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
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
            child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection("users")
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (ctx, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  }

                  return TextFormField(
                    controller: firstNameController,
                    readOnly: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: HomeAppTheme.of(context).bodyText2,
                      hintText: '${streamSnapshot.data!['first name']}',
                      hintStyle: HomeAppTheme.of(context).bodyText2,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HomeAppTheme.of(context).primaryBackground,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HomeAppTheme.of(context).primaryBackground,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: HomeAppTheme.of(context).secondaryBackground,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                    ),
                    style: HomeAppTheme.of(context).bodyText1,
                    maxLines: null,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
            child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection("users")
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (ctx, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  }

                  return TextFormField(
                    controller: lastNameController,
                    readOnly: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: HomeAppTheme.of(context).bodyText2,
                      hintText: '${streamSnapshot.data!['last name']}',
                      hintStyle: HomeAppTheme.of(context).bodyText2,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HomeAppTheme.of(context).primaryBackground,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HomeAppTheme.of(context).primaryBackground,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: HomeAppTheme.of(context).secondaryBackground,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                    ),
                    style: HomeAppTheme.of(context).bodyText1,
                    maxLines: null,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
            child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection("users")
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (ctx, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  }

                  return TextFormField(
                    controller: ageController,
                    readOnly: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: HomeAppTheme.of(context).bodyText2,
                      hintText: '${streamSnapshot.data!['age']}',
                      hintStyle: HomeAppTheme.of(context).bodyText2,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HomeAppTheme.of(context).primaryBackground,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HomeAppTheme.of(context).primaryBackground,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: HomeAppTheme.of(context).secondaryBackground,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                    ),
                    style: HomeAppTheme.of(context).bodyText1,
                    maxLines: null,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeAppButtonWidget(
                  onPressed: () async {
                    if (firstNameController != null)
                      addUserRole('first name', firstNameController.text);

                    if (lastNameController != null) {
                      addUserRole('last name', lastNameController.text);
                    }
                    if (addressController != null)
                      addUserRole('role', addressController.text);

                    if (ageController != null)
                      addUserAge(int.parse(ageController.text.trim()));
                  },
                  text: 'Save Changes',
                  options: HomeAppButtonOptions(
                    width: 130,
                    height: 40,
                    color: HomeAppTheme.of(context).primaryBtnText,
                    textStyle: HomeAppTheme.of(context).bodyText1,
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
        ])));
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

  void addUserRole(String type, String s) async {
    getCurrentUser();
    await _firestore.collection('users').doc(currentUser.uid).update({
      '$type': s,
    });
  }

  void addUserAge(int s) async {
    getCurrentUser();
    await _firestore.collection('users').doc(currentUser.uid).update({
      'age': s,
    });
  }
}
