
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:homeapp/Pages/Register/Address.dart';
import 'package:homeapp/Services/authentification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../Services/FirebaseService.dart';
import '../HomePages/homeowner.dart';
import '../NotificationPages/homeowner_notification.dart';
import '../ProfilePages/homeowner_profile.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeownerEditPageWidget extends StatefulWidget {
  const HomeownerEditPageWidget({Key? key}) : super(key: key);

  @override
  _HomeownerEditPageWidgetState createState() =>
      _HomeownerEditPageWidgetState();
}

class _HomeownerEditPageWidgetState extends State<HomeownerEditPageWidget> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;
  late final User currentUser;
  Authentication _authentication = Authentication();
  bool isImageAvailable = false;
  late String imageUrl;
  bool _isModified = false;



  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    _authentication = Authentication();
    fetchImage();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _authentication = Authentication();

  }

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

  Future<void> fetchImage() async {
    imageUrl = (await _authentication.getDataImage())!;
    imageUrl = _authentication.urlPath!;
    print(imageUrl);
    setState(() {
      isImageAvailable = imageUrl != null && imageUrl.isNotEmpty;
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
      await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).update(
          {
            'uploadedImage' : _fileURL
          }
      );
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: HomeAppTheme
            .of(context)
            .primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: HomeAppTheme
                .of(context)
                .primaryBackground,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: CupertinoColors.systemGrey,
              ),
              onPressed: () =>
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const HomeownerProfilePageWidget())),
            ),
            centerTitle: false,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(

                children: [
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
                        child: isImageAvailable
                                ? Image.network(_authentication.urlPath!.trim())
                                : Image.asset('assets/images/iconapp.png'),
                    )),


                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HomeAppButtonWidget(
                          onPressed: ()  {
                            _showPicker(context);
                          },
                          text: 'Change Photo',
                          options: HomeAppButtonOptions(
                            width: 130,
                            height: 40,
                            color: HomeAppTheme
                                .of(context)
                                .primaryBtnText,
                            textStyle: HomeAppTheme
                                .of(context)
                                .bodyText1,
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
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20, 0, 20, 16),
                    child: HomeAppButtonWidget(
                      onPressed: ()  {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const Address(fromRegister: false,)));
                      },
                      text: 'Change Address',
                      options: HomeAppButtonOptions(
                        width: 130,
                        height: 40,
                        color: HomeAppTheme
                            .of(context)
                            .primaryBtnText,
                        textStyle: HomeAppTheme
                            .of(context)
                            .bodyText1,
                        elevation: 1,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20, 0, 20, 16),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection("users")
                            .doc(currentUser.uid)
                            .snapshots(),
                        builder: (ctx, streamSnapshot) {
                          if (streamSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
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
                              labelStyle: HomeAppTheme
                                  .of(context)
                                  .bodyText2,
                              hintText: '${streamSnapshot.data!['first name']}',
                              hintStyle: HomeAppTheme
                                  .of(context)
                                  .bodyText2,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: HomeAppTheme
                                      .of(context)
                                      .primaryBackground,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: HomeAppTheme
                                      .of(context)
                                      .primaryBackground,
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
                              fillColor:
                              HomeAppTheme
                                  .of(context)
                                  .secondaryBackground,
                              contentPadding:
                              const EdgeInsetsDirectional.fromSTEB(
                                  20, 24, 0, 24),
                            ),
                            style: HomeAppTheme
                                .of(context)
                                .bodyText1,
                            maxLines: null,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20, 0, 20, 16),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection("users")
                            .doc(currentUser.uid)
                            .snapshots(),
                        builder: (ctx, streamSnapshot) {
                          if (streamSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
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
                              labelStyle: HomeAppTheme
                                  .of(context)
                                  .bodyText2,
                              hintText: '${streamSnapshot.data!['last name']}',
                              hintStyle: HomeAppTheme
                                  .of(context)
                                  .bodyText2,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: HomeAppTheme
                                      .of(context)
                                      .primaryBackground,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: HomeAppTheme
                                      .of(context)
                                      .primaryBackground,
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
                              fillColor:
                              HomeAppTheme
                                  .of(context)
                                  .secondaryBackground,
                              contentPadding:
                              const EdgeInsetsDirectional.fromSTEB(
                                  20, 24, 0, 24),
                            ),
                            style: HomeAppTheme
                                .of(context)
                                .bodyText1,
                            maxLines: null,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20, 0, 20, 16),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection("users")
                            .doc(currentUser.uid)
                            .snapshots(),
                        builder: (ctx, streamSnapshot) {
                          if (streamSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
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
                              labelStyle: HomeAppTheme
                                  .of(context)
                                  .bodyText2,
                              hintText: '${streamSnapshot.data!['age']}',
                              hintStyle: HomeAppTheme
                                  .of(context)
                                  .bodyText2,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: HomeAppTheme
                                      .of(context)
                                      .primaryBackground,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: HomeAppTheme
                                      .of(context)
                                      .primaryBackground,
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
                              fillColor:
                              HomeAppTheme
                                  .of(context)
                                  .secondaryBackground,
                              contentPadding:
                              const EdgeInsetsDirectional.fromSTEB(
                                  20, 24, 0, 24),
                            ),
                            style: HomeAppTheme
                                .of(context)
                                .bodyText1,
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
                          onPressed: () {
                            if (firstNameController.text.isNotEmpty) {
                              addUserRole(
                                  'first name', firstNameController.text);
                              _isModified = true;
                            }
                            print(firstNameController);

                            if (lastNameController.text.isNotEmpty) {
                              addUserRole('last name', lastNameController.text);
                              _isModified = true;
                            }

                            if (ageController.text.isNotEmpty) {
                              addUserAge(int.parse(ageController.text.trim()));
                              _isModified = true;
                            }
                            if(_isModified == false)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.blueGrey,
                                    content: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          'No modification have been made, press back to go the the other stage'),
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                );
                              }
                            else
                              {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const HomeownerProfilePageWidget()));
                              }



                          },
                          text: 'Save Changes',
                          options: HomeAppButtonOptions(
                            width: 130,
                            height: 40,
                            color: HomeAppTheme
                                .of(context)
                                .primaryBtnText,
                            textStyle: HomeAppTheme
                                .of(context)
                                .bodyText1,
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
                ])
        ));
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

  bool isUrlValid(String url) {
    RegExp urlRegex = RegExp(
      r"^(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ;,./?%&=]*)?$",
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegex.hasMatch(url);
  }
}
