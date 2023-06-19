import 'package:cloud_firestore/cloud_firestore.dart';

class Room{
  String? name;
  Timestamp? timestamp;
  List<String>? devices;
  String? photoUrl;

  Room();

  /*// convert Firestore document to Room object
  factory Room.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  return Room(
  name: data['name'],
  timestamp: data['timestamp'],
  devices: List<String>.from(data['devices']),
  );*/


  // convert Room object to Firestore document
  /*Map<String, dynamic> toFirestore() {
  return {
  'name': this.name,
  'timestamp': this.timestamp,
  'devices': this.devices,
  };
  }*/
  }












