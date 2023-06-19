import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../../Services/Animations.dart';
import '../../model/Room.dart';
import '../../model/sampleDevice.dart';
import '../HomePages/homeowner.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:homeapp/model/Devices.dart';
import 'package:image_picker/image_picker.dart';
import 'addQrCode.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddRoomPageWidget extends StatefulWidget {
  const AddRoomPageWidget({Key? key}) : super(key: key);

  @override
  _AddRoomPageWidgetState createState() => _AddRoomPageWidgetState();
}

class _AddRoomPageWidgetState extends State<AddRoomPageWidget> {
  final TextEditingController roomNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;
  late final User currentUser;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  late final _room = Room();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
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
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                          maxHeight: 100,
                        ),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ImageAssets.imageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              String imagePath = ImageAssets.imageList[index];
                              return GestureDetector(
                                onTap: () {
                                  // Handle the tap event for the first image
                                  // You can perform any action, such as setting the selected image or opening a dialog
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      imagePath,
                                      width: 100.0,
                                      height: 100.0,
                                    )


                                  // Add more Image widgets for additional ima
                                ),
                              );
                            }
                        ),
                      )
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: HomeAppTheme
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
                        controller: roomNameController,
                        validator: (value) =>
                        (value!.isEmpty)
                            ? '$_auth.'
                            : null,

                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Enter the room name',
                          labelStyle: HomeAppTheme
                              .of(context)
                              .bodyText2,
                          hintText: 'Enter room name...',
                          hintStyle: HomeAppTheme
                              .of(context)
                              .bodyText1
                              .override(
                            fontFamily: 'Lexend Deca',
                            color: HomeAppTheme
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
                          fillColor: HomeAppTheme
                              .of(context)
                              .secondaryBackground,
                          contentPadding:
                          EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                        ),
                        style: HomeAppTheme
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
                        HomeAppButtonWidget(
                          onPressed: () async {
                            createRoom(roomNameController.text);
                            //_room.name = roomNameController.text;

                            uploadFile();
                            Navigator.push(
                                context,
                                Animations(
                                  page:
                                  HomeownerHomePageWidget(),
                                  animationType: RouteAnimationType
                                      .slideFromBottom,
                                ));




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

                ]
            )

        ));
  }

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
          .collection('users')
          .doc(currentUser.uid)
          .collection('rooms')
          .doc(roomNameController.text)
          .update({
        'uploadedImage' : _fileURL
          });
    } catch (e) {
      print('error occured');
    }
  }

  Future<void> createRoom(String roomName) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('rooms')
        .doc(roomName)
        .set({
      'name': roomName,
      'deviceIds': [],  // initialize as an empty list
      'timestamp': FieldValue.serverTimestamp(),
      'uploadedImage' : '',
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


}
