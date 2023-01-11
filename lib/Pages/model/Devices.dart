class Device{
  String? deviceName;
  String? serialNumber;
  String? type;
  String? brand;
  String? uploadedImage;

  Device();

  Map<String, dynamic> toJson() =>{
    'name' : deviceName,
    'serial number' :serialNumber,
  'type': type,
  'brand' : brand};

  Device.fromSnapshot(snapshot)
  : deviceName = snapshot.data()['device name'],
   serialNumber = snapshot.data()['serial number'],
    type = snapshot.data()['type'],
  brand = snapshot.data()['brand'],
  uploadedImage = snapshot.data()['uploadedImage'];







}
