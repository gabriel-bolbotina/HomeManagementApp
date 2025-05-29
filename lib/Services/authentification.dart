import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Pages/StartingPages/startPage.dart';
import '../Pages/LoginPage/Login.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _urlPath;
  String? _userRole;
  String? _userName;

  // Getters
  String? get urlPath => _urlPath;
  String? get userRole => _userRole;
  String? get userName => _userName;

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      final data = await _firestore.collection("users").doc(uid).get();
      return data.data();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Get profile image
  Future<String?> getProfileImage() async {
    try {
      if (_auth.currentUser?.photoURL != null) {
        _urlPath = _auth.currentUser!.photoURL!;
        return _urlPath;
      }

      final userData = await getUserData();
      if (userData != null) {
        _urlPath = userData['uploadedImage'];
        _userRole = userData['role'];
        _userName = userData['first name'];

        return _urlPath ?? "assets/homeowner.png";
      }
      return "assets/homeowner.png";
    } catch (e) {
      print('Error getting profile image: $e');
      return "assets/homeowner.png";
    }
  }

  // Get user name
  Future<String> getUserName() async {
    try {
      if (_auth.currentUser?.displayName != null) {
        _userName = _auth.currentUser!.displayName!;
        return _userName!;
      }

      final userData = await getUserData();
      if (userData != null) {
        _userName = userData['first name'];
        return _userName ?? "user";
      }
      return "user";
    } catch (e) {
      print('Error getting user name: $e');
      return "user";
    }
  }

  // Get user role
  String? getUserRole() {
    return _userRole?.trim();
  }

  // Get image data
  String? getDataImage() {
    return _urlPath?.trim();
  }

  // Handle authentication state
  Widget handleAuthState() {
    return StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomePageWidget();
          } else {
            return const LoginPageWidget();
          }
        });
  }
}
