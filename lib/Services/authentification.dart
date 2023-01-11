import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homeapp/Pages/StartingPages/startPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Pages/LoginPage/Login.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;




  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePageWidget();
          }
          else {
            return const LoginPageWidget ();
          }
        });
  }
// StreamBuilder


  //sign in with google method

  String getProfileImage()
  {
    if(_auth.currentUser?.photoURL !=  null)
      {
        final urlpath = _auth.currentUser?.photoURL;
        if(urlpath != null)
        return urlpath;
      }
    else
      {
        return "assets/iconapp.png";
      }
    return "";
  }
}
