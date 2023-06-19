import 'package:cloud_firestore/cloud_firestore.dart';

class Device{
  String? deviceId;
  String? deviceName;
  int? serialNumber;
  String? type;
  String? brand;
  String? uploadedImage;
  Timestamp? timestamp;

  Device();

  Map<String, dynamic> toJson() =>{
    'id' : deviceId,
    'name' : deviceName,
    'serial number' :serialNumber,
  'type': type,
  'brand' : brand,
  'timestamp': timestamp};

  Device.fromSnapshot(snapshot)
  : deviceId = snapshot.data()['deviceId'],
        deviceName = snapshot.data()['device name'],
   serialNumber = snapshot.data()['serial number'],
    type = snapshot.data()['type'],
  brand = snapshot.data()['brand'],
  uploadedImage = snapshot.data()['uploadedImage'],
  timestamp = snapshot.data()['timestamp'];

  String? getBrand(){
    return brand;
  }







}
