import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
   String? firstName;
   String? lastName;
    int? age;
   String? role;
   String? address;
   String? zipCode;





  Users();

  String? getUserRole()
  {
    return this.role;
  }

  /*
  factory Users.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Users(
      firstName: data?['first name'],
      lastName: data?['last name'],
      age: data?['age'],
      role: data?['role'],
    );
  }

   */

  Users.fromSnapshot(snapshot)
  : firstName = snapshot.data()['first name'],
  lastName = snapshot.data()['last name'],
        age = snapshot.data()['age'],
  role = snapshot.data()["role"];

  Map<String, dynamic> toFirestore() {
    return {
      if (firstName != null) "first name": firstName,
      if (lastName != null) "last name": lastName,
      if (age != null) "age": age,
      if (role != null) "role": role,
    };
  }


}
