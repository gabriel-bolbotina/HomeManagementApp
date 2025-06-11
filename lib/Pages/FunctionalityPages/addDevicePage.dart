import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rive/rive.dart';
import '../../services/Animations.dart';
import '../flutter_flow/HomeAppTheme.dart';

import 'dart:developer';

import '../../services/FirebaseService.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:homeapp/model/Devices.dart';
import 'addQrCode.dart';

class AddDevicePageWidget extends StatefulWidget {
  const AddDevicePageWidget({Key? key}) : super(key: key);

  @override
  _AddDevicePageWidgetState createState() => _AddDevicePageWidgetState();
}

class _AddDevicePageWidgetState extends State<AddDevicePageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;
  late final User currentUser;
  late final Device _device;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: HomeAppTheme.of(context).primaryBackground,
        body: Stack(children: [
          const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: RiveAnimation.asset('assets/images/new_file.riv')),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
          SizedBox(height: 100),
          Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(40, 240, 40, 0),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText("Add your Smart object right away!",
                      textStyle: TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'Fira Sans',
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic)),
                  TyperAnimatedText(
                      "Your smart device will be set up in a few moments \n"
                      "\nPress Add button to continue!",
                      textStyle: TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'Fira Sans',
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic)),
                ],
              )),
          Positioned(
            top: MediaQuery.of(context).padding.top +
                10, // Account for status bar
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.3), // Optional: semi-transparent background
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: CupertinoColors.systemGrey,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
            child: HomeAppButtonWidget(
              onPressed: () => Navigator.push(
                  context,
                  Animations(
                    page: AddQRFunctionalityTPageWidget(),
                    animationType: RouteAnimationType.slideFromBottom,
                  )),
              text: '+ Add',
              options: HomeAppButtonOptions(
                width: 100,
                height: 50,
                color: const Color.fromARGB(255, 253, 238, 186),
                textStyle: HomeAppTheme.of(context).subtitle2.override(
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
}
