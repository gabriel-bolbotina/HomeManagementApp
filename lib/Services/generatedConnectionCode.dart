import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> generateConnectionCode() async {
  final random = Random();
  const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const codeLength = 8;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var uid = _auth.currentUser?.uid;

  String code = '';

  for (int i = 0; i < codeLength; i++) {
    final randomIndex = random.nextInt(chars.length);
    code += chars[randomIndex];
  }

  final codeExists = await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection('properties')
      .where('connectionCode', isEqualTo: code)
      .limit(1)
      .get()
      .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

  if (codeExists) {
    // Code is not unique, regenerate a new one
    return generateConnectionCode();
  }

  return code;
}


