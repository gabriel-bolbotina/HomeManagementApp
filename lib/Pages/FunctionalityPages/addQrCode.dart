import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:homeapp/Pages/FunctionalityPages/PhilipsHueLight.dart';
import 'package:homeapp/Pages/FunctionalityPages/addDevicePage.dart';
import 'package:homeapp/Pages/HomePages/tenant.dart';
import 'package:homeapp/Pages/flutter_flow/flutter_flow_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:developer';

import '../../services/Animations.dart';
import '../../services/FirebaseService.dart';
import '../HomePages/homeowner.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';

import 'add_functionality.dart';

class AddQRFunctionalityTPageWidget extends StatefulWidget {
  const AddQRFunctionalityTPageWidget({Key? key}) : super(key: key);

  @override
  _AddQRFunctionalityTPageWidgetState createState() =>
      _AddQRFunctionalityTPageWidgetState();
}

class _AddQRFunctionalityTPageWidgetState
    extends State<AddQRFunctionalityTPageWidget> {
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;
  late final User currentUser;
  late var qrCode;
  final regex = RegExp(r'M:(\d+)');

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
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .collection("devices")
          .doc(deviceNameController.text)
          .update({'uploadedImage': _fileURL});
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

  Future addUserDeviceDetails(
      String deviceName, int serialNumber, String type, String brand) async {
    getCurrentUser();
    var newDeviceDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection("devices")
        .doc();

    String deviceId = newDeviceDoc.id;
    await newDeviceDoc.set({
      'device id': deviceId,
      'device name': deviceName,
      'serial number': serialNumber,
      'type': type,
      'brand': brand,
      'uploadedImage': '',
      'timestamp': FieldValue.serverTimestamp(),
    });
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
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: false,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
              child: Container(
                width: MediaQuery.of(context).size.height * 0.6,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      16.0), // Adjust the border radius as needed

                  child: MobileScanner(
                      fit: BoxFit.cover,
                      onDetect: (BarcodeCapture barcode) {
                        if (barcode.raw == null) {
                          debugPrint('Failed to scan Barcode');
                        } else {
                          qrCode = barcode.raw!;
                          debugPrint('Barcode found! $qrCode');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors
                                    .transparent, // Transparent background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded corners
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Found QR code'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Barcode found! $qrCode'),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: Text('Continue'),
                                            onPressed: () {
                                              if (qrCode != '' &&
                                                  isValidPhilipsHueQrCode(
                                                      qrCode)) {
                                                addUserDeviceDetails(
                                                    "Smart white light lamp",
                                                    123,
                                                    "Smart light bulb",
                                                    "Philips");
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    Animations(
                                                      page:
                                                          AddFunctionalityTPageWidget(
                                                              0),
                                                      animationType:
                                                          RouteAnimationType
                                                              .slideFromBottom,
                                                    ));
                                              }
                                              print(qrCode);
                                              Navigator.push(
                                                context,
                                                Animations(
                                                  page:
                                                      AddFunctionalityTPageWidget(
                                                          123),
                                                  animationType:
                                                      RouteAnimationType
                                                          .slideFromBottom,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        ;

                        //launchUrlString(code);
                      }),
                ),
              )),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeAppButtonWidget(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        Animations(
                          page: AddFunctionalityTPageWidget(0),
                          animationType: RouteAnimationType.slideFromBottom,
                        ));
                    /*if (qrCode != '' && qrCode.contains("HUE")) {
                      addUserDeviceDetails(
                          "Philips Hue Light bulb",
                          123,
                          "Smart light bulb",
                          "Philips");
                      Navigator.push(
                          context,
                          Animations(
                            page:
                                const PhilipsLight(),
                            animationType: RouteAnimationType
                                .slideFromBottom,
                          ));
                    }

                    else if(qrCode.isNull){
                      //addUserDetails(deviceNameController.text, int.parse(serialNumberController.text), typeController.text, brandController.text);
                      print("other device\n");
                      Navigator.push(
                          context,
                          Animations(
                            page:
                            const PhilipsLight(),
                            animationType: RouteAnimationType
                                .slideFromBottom,
                          ));
                    }
                    uploadFile();
                    Navigator.pop(context);*/
                  },
                  text: 'Scan devices',
                  options: HomeAppButtonOptions(
                    width: 130,
                    height: 60,
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

  bool isValidPhilipsHueQrCode(String code) {
    final RegExp regExp = RegExp(
        r'^HUE:Z:[0-9A-F]+\sM:[0-9A-F]+\sD:[0-9A-F]+\sA:[0-9A-F]+$',
        caseSensitive: false);

    return regExp.hasMatch(code);
  }
}
