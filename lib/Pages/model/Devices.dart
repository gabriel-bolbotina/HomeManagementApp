class Device{
  String? serialNumber;
  int? id;
  String? type;
  String? brand;

  Device();

  Map<String, dynamic> toJson() =>{
    'serial number' :serialNumber,
  'id' :id,
  'type': type,
  'brand' : brand};



}
