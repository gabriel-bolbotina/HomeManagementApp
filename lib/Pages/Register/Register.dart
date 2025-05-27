import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'dart:developer';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';

import 'package:homeapp/model/User.dart';

class RegisterPageWidget extends StatefulWidget {
  const RegisterPageWidget({Key? key}) : super(key: key);

  @override
  _RegisterPageWidgetState createState() => _RegisterPageWidgetState();
}

class _RegisterPageWidgetState extends State<RegisterPageWidget> {
  TextEditingController? confirmPasswordController;
  late bool confirmPasswordVisibility;
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  late bool passwordVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  bool isloading = false;
  late User currentUser;
  static Users _user = Users();

  @override
  void initState() {
    super.initState();
    confirmPasswordController = TextEditingController();
    confirmPasswordVisibility = false;
    passwordVisibility = false;
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

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool emailConfirmed() {
    if (emailAddressController.text.isEmpty) {
      errorMessage("Please write your email address!");
      return false;
    }
    if (isValidEmail(emailAddressController.text) == false) {
      errorMessage("Please write a valid email address!");
      return false;
    } else
      return true;
  }

  bool firstNameConfirmed() {
    if (firstNameController.text.isEmpty) {
      errorMessage("Please write your first name!");
      return false;
    } else
      return true;
  }

  bool lastNameConfirmed() {
    if (lastNameController.text.isEmpty) {
      errorMessage("Please write your last name!");
      return false;
    } else
      return true;
  }

  bool ageConfirmed() {
    if (ageController.text.isEmpty) {
      errorMessage("Please write your age!");
      return false;
    }

    try {
      int _age = int.parse(ageController.text);
      if (_age <= 16) {
        errorMessage("You must be over 16 to use this app!");
        return false;
      } else if (_age <= 0) {
        errorMessage("Please write an eligible age!");
        return false;
      } else {
        return true;
      }
    } catch (e) {
      errorMessage("Please enter a valid number for age!");
      return false;
    }
  }

  @override
  void dispose() {
    confirmPasswordController?.dispose();
    emailAddressController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  Future addUserDetails(
      String uid, String firstName, String lastName, int age) async {
    //Crearea documentului asociat cu ID ul utilizatorului
    // și urcarea datelor în baza de date
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'first name': firstName,
      'last name': lastName,
      'age': age,
      'role': '',
      'address': '',
      'zip code': '',
      'uploadedImage': '',
    });
  }

  bool confirmedPassword() {
    if (isPasswordSafe(passwordController.text) == false) {
      return false;
    }
    if (passwordController.text != confirmPasswordController?.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Passwords don\'t match!',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  bool isPasswordSafe(String password) {
    // Check if password has at least one uppercase letter
    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    if (hasUppercase == false) {
      errorMessage(
          "Your password should contain at least one uppercase letter");
    }
    // Check if password has at least one lowercase letter
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    if (hasLowercase == false) {
      errorMessage(
          "Your password should contain at least one lowercase letter");
    }
    // Check if password has at least one digit
    bool hasNumber = password.contains(new RegExp(r'[0-9]'));
    if (hasNumber == false) {
      errorMessage("Your password should contain at least one digit");
    }
    // Check if password has at least one symbol
    bool hasSymbol = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (hasSymbol == false) {
      errorMessage("Your password should contain at least one symbol");
    }
    // Check if all criteria are met
    return hasUppercase && hasLowercase && hasNumber && hasSymbol;
  }

  Future signUp() async {
    if (emailConfirmed() &&
        confirmedPassword() &&
        firstNameConfirmed() &&
        lastNameConfirmed() &&
        ageConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailAddressController.text.trim(),
            password: passwordController.text.trim());
        getCurrentUser();
        addUserDetails(
            currentUser.uid.toString(),
            firstNameController.text.trim(),
            lastNameController.text.trim(),
            int.parse(ageController.text.trim()));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sucessfully added your info, please continue'),
            ),
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.pushReplacementNamed(context, 'address_screen');

        setState(() {
          isloading = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          log('The password provided is too weak.');
          errorMessage('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          log('The account already exists for that email.');
          errorMessage('The account already exists for that email.');
        } else {
          errorMessage("Oops, registration failed!");
        }
      }
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
              selectionColor: CupertinoColors.systemGrey,
            ),
            content: new Text(
              'Do you want to exit an App',
              selectionColor: CupertinoColors.systemGrey,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(false),
                },
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => {Navigator.of(context).pop(), exit(0)},
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
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
              onPressed: () =>
                  {Navigator.pushReplacementNamed(context, 'homescreen')},
            ),
            backgroundColor: HomeAppTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
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
                            Navigator.pushReplacementNamed(
                                context, 'homescreen');
                          },
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0.55),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 10, 0, 0),
                          child: Text(
                            'Back',
                            style: HomeAppTheme.of(context).title1.override(
                                  fontFamily: 'Poppins',
                                  color: HomeAppTheme.of(context).gray600,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                            child: Text(
                              'Create your account by filling in the information below to access the app.',
                              style: HomeAppTheme.of(context)
                                  .subtitle2
                                  .override(
                                    fontFamily: 'Poppins',
                                    color:
                                        HomeAppTheme.of(context).secondaryText,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: HomeAppTheme.of(context).secondaryBackground,
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
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Your email address...',
                          labelStyle: HomeAppTheme.of(context).bodyText2,
                          hintText: 'Enter your email...',
                          hintStyle: HomeAppTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Lexend Deca',
                                color: HomeAppTheme.of(context).secondaryText,
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
                          fillColor:
                              HomeAppTheme.of(context).secondaryBackground,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                        ),
                        style: HomeAppTheme.of(context).bodyText1,
                        maxLines: 1,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: HomeAppTheme.of(context).secondaryBackground,
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
                        controller: passwordController,
                        validator: (value) =>
                            (value!.isEmpty) ? 'Please enter password' : null,
                        obscureText: !passwordVisibility,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: HomeAppTheme.of(context).bodyText2,
                          hintText: 'Please enter your password...',
                          hintStyle: HomeAppTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Lexend Deca',
                                color: HomeAppTheme.of(context).secondaryText,
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
                          fillColor:
                              HomeAppTheme.of(context).secondaryBackground,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                              () => passwordVisibility = !passwordVisibility,
                            ),
                            focusNode: FocusNode(skipTraversal: true),
                            child: Icon(
                              passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: HomeAppTheme.of(context).secondaryText,
                              size: 22,
                            ),
                          ),
                        ),
                        style: HomeAppTheme.of(context).bodyText1,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: HomeAppTheme.of(context).secondaryBackground,
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
                        controller: confirmPasswordController,
                        obscureText: !confirmPasswordVisibility,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: HomeAppTheme.of(context).bodyText2,
                          hintText: 'Please enter your password...',
                          hintStyle: HomeAppTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Lexend Deca',
                                color: HomeAppTheme.of(context).secondaryText,
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
                          fillColor:
                              HomeAppTheme.of(context).secondaryBackground,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                              () => confirmPasswordVisibility =
                                  !confirmPasswordVisibility,
                            ),
                            focusNode: FocusNode(skipTraversal: true),
                            child: Icon(
                              confirmPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: HomeAppTheme.of(context).secondaryText,
                              size: 22,
                            ),
                          ),
                        ),
                        style: HomeAppTheme.of(context).bodyText1,
                        maxLines: 1,
                      ),
                    ),
                  ),

                  //first name
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: HomeAppTheme.of(context).secondaryBackground,
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
                        controller: firstNameController,
                        validator: (value) =>
                            (value!.isEmpty) ? 'Please enter your name' : null,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Your first name ...',
                          labelStyle: HomeAppTheme.of(context).bodyText2,
                          hintText: 'Enter your first name...',
                          hintStyle: HomeAppTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Lexend Deca',
                                color: HomeAppTheme.of(context).secondaryText,
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
                          fillColor:
                              HomeAppTheme.of(context).secondaryBackground,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                        ),
                        style: HomeAppTheme.of(context).bodyText1,
                        maxLines: 1,
                      ),
                    ),
                  ),

                  //last name
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: HomeAppTheme.of(context).secondaryBackground,
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
                        controller: lastNameController,
                        validator: (value) => (value!.isEmpty)
                            ? 'Please enter your last name'
                            : null,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Your last name ...',
                          labelStyle: HomeAppTheme.of(context).bodyText2,
                          hintText: 'Enter your last name...',
                          hintStyle: HomeAppTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Lexend Deca',
                                color: HomeAppTheme.of(context).secondaryText,
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
                          fillColor:
                              HomeAppTheme.of(context).secondaryBackground,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                        ),
                        style: HomeAppTheme.of(context).bodyText1,
                        maxLines: 1,
                      ),
                    ),
                  ),

                  //age
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: HomeAppTheme.of(context).secondaryBackground,
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
                        controller: ageController,
                        validator: (value) =>
                            (value!.isEmpty) ? 'Please enter your age' : null,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Your age...',
                          labelStyle: HomeAppTheme.of(context).bodyText2,
                          hintText: 'Enter your age...',
                          hintStyle: HomeAppTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Lexend Deca',
                                color: HomeAppTheme.of(context).secondaryText,
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
                          fillColor:
                              HomeAppTheme.of(context).secondaryBackground,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                        ),
                        style: HomeAppTheme.of(context).bodyText1,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: HomeAppButtonWidget(
                      onPressed: () {
                        signUp();
                        addUser();
                        //daca in metoda signUp se face asta de ce o mai fac și aici???
                        /*addUserDetails(
                            currentUser.uid,
                            firstNameController.text,
                            lastNameController.text,
                            int.parse(ageController.text)); */
                      },
                      text: 'Create Account',
                      options: HomeAppButtonOptions(
                        width: 270,
                        height: 50,
                        color: const Color.fromARGB(255, 255, 242, 176),
                        textStyle: HomeAppTheme.of(context).subtitle2.override(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 16,
                            ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  void addUser() {
    _user.firstName = firstNameController.text.trim();
    _user.lastName = lastNameController.text.trim();
    _user.age = int.parse(ageController.text);
  }
}

void showMessage(String s) {
  print(s);
}
