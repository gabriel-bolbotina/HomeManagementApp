import 'dart:io';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:homeapp/Pages/HomePages/tenant.dart';

import '../../Services/authentication.dart';
import '../HomePages/homeowner.dart';
import '../StartingPages/startPage.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
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
  final passwordLoginController = TextEditingController();
  final passwordConfirmedLoginController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  late bool passwordLoginVisibility;
  late bool emailAddressVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late User currentUser;

  Future Navigation() async {
    try {
      developer.log('Starting navigation for user', name: 'LoginPage.Navigation');
      getCurrentUser();

      var userRef =
          FirebaseFirestore.instance.collection("users").doc(currentUser.uid);
      DocumentSnapshot doc = await userRef.get();
      
      if (!doc.exists) {
        developer.log('User document does not exist for uid: ${currentUser.uid}', 
            name: 'LoginPage.Navigation', level: 1000);
        _showErrorDialog('User profile not found. Please contact support.');
        return;
      }
      
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        developer.log('User document data is null for uid: ${currentUser.uid}', 
            name: 'LoginPage.Navigation', level: 1000);
        _showErrorDialog('Invalid user profile data. Please contact support.');
        return;
      }

      developer.log('User role: ${data["role"]}, address: ${data["address"]}', 
          name: 'LoginPage.Navigation');

      if (data["address"] == '') {
        developer.log('Navigating to address screen', name: 'LoginPage.Navigation');
        Navigator.pushNamed(context, "address_screen");
      } else if (data["address"] != '' && data["role"] == '') {
        developer.log('Navigating to role screen', name: 'LoginPage.Navigation');
        Navigator.pushNamed(context, "role_screen");
      }

      if (data["role"] == "homeowner") {
        developer.log('Navigating to homeowner main', name: 'LoginPage.Navigation');
        Navigator.pushNamed(context, "homeowner_main");
      }
      if (data["role"] == "tenant") {
        developer.log('Navigating to tenant main', name: 'LoginPage.Navigation');
        Navigator.pushNamed(context, "tenant_main");
      }
      if (data["role"] == "landlord") {
        developer.log('Navigating to landlord main', name: 'LoginPage.Navigation');
        Navigator.pushNamed(context, "landlord_main");
      }
    } catch (e, stackTrace) {
      developer.log('Navigation failed', 
          name: 'LoginPage.Navigation', 
          error: e, 
          stackTrace: stackTrace,
          level: 1000);
      _showErrorDialog('Navigation failed. Please try again.');
    }
  }

  Future googleSignIn() async {
    setState(() {
      isloading = true;
    });
    
    developer.log('Starting Google Sign In', name: 'LoginPage.googleSignIn');
    FirebaseService service = new FirebaseService();
    
    try {
      await service.signInwithGoogle();
      developer.log('Google Sign In successful', name: 'LoginPage.googleSignIn');
      Navigation();
    } catch (e, stackTrace) {
      developer.log('Google Sign In failed', 
          name: 'LoginPage.googleSignIn', 
          error: e, 
          stackTrace: stackTrace,
          level: 1000);
          
      String errorMessage = 'Google Sign In failed. Please try again.';
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            errorMessage = 'An account already exists with a different sign-in method.';
            break;
          case 'invalid-credential':
            errorMessage = 'Invalid Google credentials. Please try again.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Google Sign In is not enabled. Please contact support.';
            break;
          case 'user-disabled':
            errorMessage = 'This account has been disabled. Please contact support.';
            break;
          case 'user-not-found':
            errorMessage = 'No account found. Please create an account first.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password. Please try again.';
            break;
          case 'network-request-failed':
            errorMessage = 'Network error. Please check your connection and try again.';
            break;
          default:
            errorMessage = e.message ?? 'Google Sign In failed. Please try again.';
        }
        developer.log('Firebase Auth Exception: ${e.code} - ${e.message}', 
            name: 'LoginPage.googleSignIn', level: 1000);
      } else if (e is PlatformException) {
        errorMessage = 'Platform error: ${e.message ?? "Unknown platform error"}';
        developer.log('Platform Exception: ${e.code} - ${e.message}', 
            name: 'LoginPage.googleSignIn', level: 1000);
      }
      
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  String? getFirstName() {
    String firstName;
    getCurrentUser();
    List<String> spiltName = currentUser.displayName!.split(" ");
    firstName = spiltName[0];
    return firstName;
  }

  String? getLastName() {
    String lastName;
    getCurrentUser();
    List<String> spiltName = currentUser.displayName!.split(" ");
    lastName = spiltName[1];
    return lastName;
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
        developer.log('Current user retrieved: ${currentUser.uid}', 
            name: 'LoginPage.getCurrentUser');
      } else {
        developer.log('No current user found', 
            name: 'LoginPage.getCurrentUser', level: 1000);
      }
    } catch (e, stackTrace) {
      developer.log('Failed to get current user', 
          name: 'LoginPage.getCurrentUser', 
          error: e, 
          stackTrace: stackTrace,
          level: 1000);
    }
  }

  Future errorMessage(String message) async {
    return await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          title: new Text(
            message,
            selectionColor: CupertinoColors.systemGrey,
            style: TextStyle(
                color: Colors.grey, fontFamily: 'Lexend Deca', fontSize: 15),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: new Text('OK'),
            ),
          ]),
    );
  }

  Future signIn() async {
    if (!_validateForm()) {
      return;
    }
    
    developer.log('Starting email/password sign in', name: 'LoginPage.signIn');
    
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddressController.text.trim(),
          password: passwordLoginController.text.trim());
      
      developer.log('Email/password sign in successful for user: ${credential.user?.uid}', 
          name: 'LoginPage.signIn');
      Navigation();
    } on FirebaseAuthException catch (e, stackTrace) {
      developer.log('Firebase Auth Exception during sign in', 
          name: 'LoginPage.signIn', 
          error: e, 
          stackTrace: stackTrace,
          level: 1000);
          
      String errorMessage = 'Sign in failed. Please try again.';
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address format.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled. Please contact support.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection and try again.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials. Please check your email and password.';
          break;
        default:
          errorMessage = e.message ?? 'Sign in failed. Please try again.';
      }
      
      _showErrorDialog(errorMessage);
    } catch (e, stackTrace) {
      developer.log('Unexpected error during sign in', 
          name: 'LoginPage.signIn', 
          error: e, 
          stackTrace: stackTrace,
          level: 1000);
      _showErrorDialog('An unexpected error occurred. Please try again.');
    }
  }

  Future addUserDetails(String uid, String? firstName, String? lastName) async {
    try {
      developer.log('Adding user details for uid: $uid', 
          name: 'LoginPage.addUserDetails');
          
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'first name': firstName ?? "",
        'last name': lastName,
        'age': "",
        'role': 'o',
        'address': '',
        'zip code': '',
        'uploadedImage': '',
      });
      
      developer.log('User details added successfully for uid: $uid', 
          name: 'LoginPage.addUserDetails');
    } catch (e, stackTrace) {
      developer.log('Failed to add user details for uid: $uid', 
          name: 'LoginPage.addUserDetails', 
          error: e, 
          stackTrace: stackTrace,
          level: 1000);
      rethrow;
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePageWidget(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
        backgroundColor: HomeAppTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: CupertinoColors.systemGrey,
              ),
              onPressed: () => {Navigator.of(context).push(_createRoute())},
            ),
            backgroundColor: HomeAppTheme.of(context).primaryBackground,
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
                              color: HomeAppTheme.of(context).gray600,
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
                            style: HomeAppTheme.of(context).title1.override(
                                  fontFamily: 'Outfit',
                                  color: HomeAppTheme.of(context).gray600,
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
                              style:
                                  HomeAppTheme.of(context).subtitle2.override(
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
                        validator: (value) =>
                            (value!.isEmpty) ? 'Please enter email' : null,
                        maxLines: 1,
                        obscureText: false,
                        //obscureText: !emailAddressVisibility,
                        decoration: InputDecoration(
                          labelText: 'Your email address...',
                          labelStyle:
                              HomeAppTheme.of(context).bodyText2.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                          hintText: 'Enter your email...',
                          hintStyle:
                              HomeAppTheme.of(context).bodyText1.override(
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
                        style: HomeAppTheme.of(context).bodyText1.override(
                              fontFamily: 'Outfit',
                              color: Color(0xFF0F1113),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                        expands: false,
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
                          labelStyle:
                              HomeAppTheme.of(context).bodyText2.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                          hintText: 'Please enter your password...',
                          hintStyle:
                              HomeAppTheme.of(context).bodyText1.override(
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
                            onTap: () => setState(
                              () => passwordLoginVisibility =
                                  !passwordLoginVisibility,
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
                        style: HomeAppTheme.of(context).bodyText1.override(
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
                    child: HomeAppButtonWidget(
                      //implementam cu firebase

                      onPressed: () {
                        signIn();
                      },
                      text: 'Login',
                      options: HomeAppButtonOptions(
                        width: 270,
                        height: 50,
                        color: HomeAppTheme.of(context).primaryColor,
                        textStyle: HomeAppTheme.of(context).subtitle2.override(
                              fontFamily: 'Poppins',
                              color: HomeAppTheme.of(context).primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                        elevation: 3,
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.transparent,
                        ),
                        borderRadius: 20,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child: SignInButton(Buttons.Google,
                          text: "Sign in with Google", onPressed: () {
                        googleSignIn();
                      })),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                        //implementam cu firebase
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                print("forgot password");
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: CupertinoColors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ]),
                  ),
                ],
              ),
            )));
  }

  void showMessage(String s) {
    developer.log('Show message: $s', name: 'LoginPage.showMessage');
  }
  
  bool _validateForm() {
    final email = emailAddressController.text.trim();
    final password = passwordLoginController.text.trim();
    
    if (email.isEmpty) {
      _showErrorDialog('Please enter your email address.');
      return false;
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showErrorDialog('Please enter a valid email address.');
      return false;
    }
    
    if (password.isEmpty) {
      _showErrorDialog('Please enter your password.');
      return false;
    }
    
    if (password.length < 6) {
      _showErrorDialog('Password must be at least 6 characters long.');
      return false;
    }
    
    return true;
  }
  
  void _showErrorDialog(String message) {
    developer.log('Showing error dialog: $message', 
        name: 'LoginPage._showErrorDialog');
        
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(
            color: Colors.red[700],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: HomeAppTheme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
