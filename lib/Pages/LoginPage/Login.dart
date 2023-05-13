import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:homeapp/Pages/HomePages/tenant.dart';

import '../../Services/authentification.dart';
import '../HomePages/homeowner.dart';
import '../StartingPages/startPage.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeapp/Services/FirebaseService.dart';
//import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final emailAddressController = TextEditingController();
  final passwordLoginController =TextEditingController();
  final passwordConfirmedLoginController =TextEditingController() ;

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  late bool passwordLoginVisibility;
  late bool emailAddressVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late User currentUser;




  Future Navigation() async {
    getCurrentUser();

    var userRef = FirebaseFirestore.instance.collection("users").doc(
        currentUser.uid);
    DocumentSnapshot doc = await userRef.get();
    final data = doc.data() as Map<String, dynamic>;


/*
    FireBaseFirestore.instance.collection("users).where("uid", isNotEqualTo : currentUser.uid)
      {
        addUserDetails(currentUser.uid, getFirstName(), getLastName());
        Navigator.pushNamed(context, "address_screen");
      }



 */

    if (data["address"] == '') {
      Navigator.pushNamed(context, "address_screen");
    }

    else if (data["address"] != '' && data["role"] == '') {
      Navigator.pushNamed(context, "role_screen");
    }


      if (data["role"] == "homeowner") {
        Navigator.pushNamed(context, "homeowner_main");
      }
      if (data["role"] == "tenant") {
        Navigator.pushNamed(context, "tenant_main");
      }
      if (data["role"] == "landlord") {
        Navigator.pushNamed(context, "landlord_main");
      }

  }


  Future googleSignIn() async{
    setState(() {
      isloading = true;
    });
    FirebaseService service = new FirebaseService();
    try {
      await service.signInwithGoogle();
      Navigation();

    } catch(e){
      if(e is FirebaseAuthException){
        showMessage(e.message!);
      }
    }

    setState(() {
      isloading = false;
    });















  }






  String? getFirstName()
  {
    String firstName;
    getCurrentUser();
    List<String> spiltName =currentUser.displayName!.split(" ");
    firstName = spiltName[0];
    return firstName;

  }

  String? getLastName()
  {
    String lastName;
    getCurrentUser();
    List<String> spiltName =currentUser.displayName!.split(" ");
    lastName = spiltName[1];
    return lastName;
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
        print(currentUser.uid);
      }
    } catch (e) {
      print(e);
    }
  }


  
  Future errorMessage(String message)
  async {
    return await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
          title: new Text(message,
            selectionColor: CupertinoColors.systemGrey,
            style: TextStyle(color: Colors.grey, fontFamily: 'Lexend Deca', fontSize: 15),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: new Text('OK'),
            ),
          ]
      ),
    );
  }

  Future signIn() async{
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailAddressController.text.trim(),
            password: passwordLoginController.text.trim()
        );
        Navigation();


      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          errorMessage("Incorrect credentials!") ?? false;
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }


  }

  Future addUserDetails(String uid,
      String? firstName, String? lastName) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid' : uid,
      'first name': firstName ?? "",
      'last name': lastName,
      'age': "",
      'role': 'o',
      'address' : '',
      'zip code': '',
      'uploadedImage': '',

    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          HomePageWidget(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    passwordLoginVisibility = false;
    emailAddressVisibility = false;
  }

  @override
  void dispose() {
    emailAddressController.dispose();
    passwordLoginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF1F4F8),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                color: CupertinoColors.systemGrey,),
              onPressed: () =>{ Navigator.of(context).push(_createRoute())},
            ),
            backgroundColor: FlutterFlowTheme
                .of(context)
                .primaryBackground,
            automaticallyImplyLeading: false,
            title: Align(
              alignment: AlignmentDirectional(-0.3, -0.05),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-0.1, -0.1),
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
                              //context.pop();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                          child: Text(
                            'Back',
                            style: FlutterFlowTheme
                                .of(context)
                                .title1
                                .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme
                                  .of(context)
                                  .gray600,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0,
          ),
        ),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
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
                            padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                            child: Text(
                              'Access your account by logging in below.',
                              style: FlutterFlowTheme
                                  .of(context)
                                  .subtitle2
                                  .override(
                                fontFamily: 'Outfit',
                                color: Color(0xFF57636C),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                        controller: emailAddressController,
                        validator: (value) => (value!.isEmpty)
                            ? 'Please enter email'
                            : null,
                        maxLines: 1,
                        obscureText: false,
                        //obscureText: !emailAddressVisibility,
                        decoration: InputDecoration(
                          labelText: 'Your email address...',
                          labelStyle: FlutterFlowTheme
                              .of(context)
                              .bodyText2
                              .override(
                            fontFamily: 'Outfit',
                            color: Color(0xFF57636C),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText: 'Enter your email...',
                          hintStyle: FlutterFlowTheme
                              .of(context)
                              .bodyText1
                              .override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF57636C),
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
                          fillColor: Colors.white,
                          contentPadding:
                          EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                        ),
                        style: FlutterFlowTheme
                            .of(context)
                            .bodyText1
                            .override(
                          fontFamily: 'Outfit',
                          color: Color(0xFF0F1113),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        expands:  false,

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                        controller: passwordLoginController,
                        obscureText: !passwordLoginVisibility,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: FlutterFlowTheme
                              .of(context)
                              .bodyText2
                              .override(
                            fontFamily: 'Outfit',
                            color: Color(0xFF57636C),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText: 'Please enter your password...',
                          hintStyle: FlutterFlowTheme
                              .of(context)
                              .bodyText1
                              .override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF57636C),
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
                          fillColor: Colors.white,
                          contentPadding:
                          EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                          suffixIcon: InkWell(
                            onTap: () =>
                                setState(
                                      () =>
                                  passwordLoginVisibility = !passwordLoginVisibility,
                                ),
                            focusNode: FocusNode(skipTraversal: true),
                            child: Icon(
                              passwordLoginVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Color(0xFF57636C),
                              size: 22,
                            ),
                          ),
                        ),
                        style: FlutterFlowTheme
                            .of(context)
                            .bodyText1
                            .override(
                          fontFamily: 'Outfit',
                          color: Color(0xFF0F1113),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        expands: false,
                      ),
                    ),
                  ),




                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: FFButtonWidget(
                      //implementam cu firebase

                      onPressed: () {
                        signIn();

                      },
                      text: 'Login',
                      options: FFButtonOptions(
                        width: 270,
                        height: 50,
                        color: const Color.fromARGB(90, 123, 192, 9),
                        textStyle: FlutterFlowTheme
                            .of(context)
                            .subtitle2
                            .override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme
                              .of(context)
                              .primaryBtnText,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        elevation: 3,
                        borderSide: BorderSide(
                          width: 1,
                        ),
                        borderRadius: 20,
                      ),
                    ),

                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child:
                      SignInButton(
                        Buttons.Google,
                        text: "Sign in with Google",
                        onPressed: () {
                          googleSignIn();

                        }

                      )
                  ),
                  SizedBox(height: 10),



                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      //implementam cu firebase
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [GestureDetector(
                        onTap: ()
                    {
                      print("forgot password");
                    },
                        child: Text(
                       'Forgot password?',
                        style: TextStyle(
                        color: CupertinoColors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        )

                        ),


                    ]
                    ),

                  ),






                ],
              ),
            )
        )
    );
  }

  void showMessage(String s) {
    print(s);
  }


}
