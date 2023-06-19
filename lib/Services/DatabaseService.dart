import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeapp/model/User.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final Users _user;
  DatabaseService(this._user, this.firstName);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;

  late final String firstName;



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


  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // update user data
  Future updateUserData(String firstName, String lastName,
      int age, String role) async {
    getCurrentUser();
    return await userCollection.doc(currentUser.uid).set({
      'uid': currentUser.uid,
      'first name': firstName,
      'last name': lastName,
      'age' : age,
      'role': role,
    });
  }

  // get user data
  Future getUserData() async {
    QuerySnapshot snapshot = await userCollection.where('uid', isEqualTo: currentUser.uid).get();
    return snapshot;
  }

  Future<String?> getUserField(String s)
  async {
    QuerySnapshot snapshot = await userCollection.where('uid', isEqualTo: currentUser.uid).get();
   Users.fromSnapshot(snapshot);
   firstName = _user.firstName!;
   return null;
  }

  String getFirstName()
  {
    return firstName;
  }
}
