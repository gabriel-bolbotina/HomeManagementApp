import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String firstName;
  final String lastName;
  final int? age;
  final String address;
  final String zipCode;
  final String uploadedImage;

  const AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    this.age,
    required this.address,
    required this.zipCode,
    required this.uploadedImage,
  });

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return AppUser(
      uid: doc.id,
      firstName: data?['first name'] ?? '',
      lastName: data?['last name'] ?? '',
      age: _parseAge(data?['age']),
      address: data?['address'] ?? '',
      zipCode: data?['zip code'] ?? '',
      uploadedImage: data?['uploadedImage'] ?? '',
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      firstName: data['first name'] ?? '',
      lastName: data['last name'] ?? '',
      age: _parseAge(data['age']),
      address: data['address'] ?? '',
      zipCode: data['zip code'] ?? '',
      uploadedImage: data['uploadedImage'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'first name': firstName,
      'last name': lastName,
      'age': age,
      'address': address,
      'zip code': zipCode,
      'uploadedImage': uploadedImage,
    };
  }

  AppUser copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    int? age,
    String? address,
    String? zipCode,
    String? uploadedImage,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      uploadedImage: uploadedImage ?? this.uploadedImage,
    );
  }

  String get fullName => '$firstName $lastName'.trim();
  
  bool get hasAddress => address.isNotEmpty;
  
  bool get isProfileComplete => 
      firstName.isNotEmpty && 
      lastName.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          age == other.age &&
          address == other.address &&
          zipCode == other.zipCode &&
          uploadedImage == other.uploadedImage;

  @override
  int get hashCode =>
      uid.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      age.hashCode ^
      address.hashCode ^
      zipCode.hashCode ^
      uploadedImage.hashCode;

  @override
  String toString() {
    return 'AppUser(uid: $uid, firstName: $firstName, lastName: $lastName, address: $address)';
  }
  
  static int? _parseAge(dynamic age) {
    if (age == null) return null;
    if (age is int) return age;
    if (age is String) return int.tryParse(age);
    return null;
  }
}