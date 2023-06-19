import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homeapp/Pages/StartingPages/startPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Pages/LoginPage/Login.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? urlPath;
  String? userRole;
  String? userName;

  getDataImage() {
    final urlPath = this.urlPath;
    if (urlPath != null) {
      return urlPath.trim() ?? "";
    }
  }

  getUserRole() {
    final userRole = this.userRole;
    if (userRole != null) {
      return userRole.trim() ?? "";
    }
  }

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomePageWidget();
          } else {
            return const LoginPageWidget();
          }
        });
  }
// StreamBuilder

  //sign in with google method

  Future<String?> getProfileImage() async {
    if (_auth.currentUser?.photoURL != null) {
      urlPath = _auth.currentUser!.photoURL!;
      return urlPath;
    } else {
      var uid = _auth.currentUser?.uid;
      var data =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      urlPath = data['uploadedImage'];
      userRole = data['role'];
      userName = data['first name'];
      print(data['uploadedImage']);
      print(urlPath);
      print(userRole);
      if (urlPath != null) {
        print("$_auth.currentUser?.email in authentification");
      } else {
        return "assets/homeowner.png";
      }
    }
    return urlPath;
  }

  Future<String?> getUserName() async {
    if (_auth.currentUser?.displayName != null) {
      userName = _auth.currentUser!.displayName!;
    } else {
      var uid = _auth.currentUser?.uid;
      var data =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      userName = data['first name'];
      print(data['first name']);
      if (userName != null) {
        return userName;
        print("$_auth.currentUser?.email in authentification");
      } else {
        return "user";
      }
    }
    return "";
  }
}
