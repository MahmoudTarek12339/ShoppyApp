
class AddressModel{
  late String uId;
  late String streetName;
  late String cityName;
  late String buildingNumber;
  late String floorNumber;
  late String apartmentNumber;
  late String phoneNumber;
  late double userAddressLat;
  late double userAddressLng;

  void setId(String id){
    this.uId=id;
  }

  AddressModel({
    required this.streetName,
    required this.cityName,
    required this.buildingNumber,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.phoneNumber,
    required this.userAddressLat,
    required this.userAddressLng
  });
  AddressModel.fromJson(Map<String,dynamic>? json) {
    streetName=json!['streetName'];
    cityName=json['cityName'];
    buildingNumber=json['buildingNumber'];
    floorNumber=json['floorNumber'];
    apartmentNumber=json['apartmentNumber'];
    phoneNumber=json['phoneNumber'];
    userAddressLat=json['userAddressLat'];
    userAddressLng=json['userAddressLng'];
    uId=json['id'];
  }
  Map<String,dynamic> toMap(){
    return
      {'streetName':streetName,
        'cityName':cityName,
        'buildingNumber':buildingNumber,
        'floorNumber':floorNumber,
        'apartmentNumber':apartmentNumber,
        'phoneNumber':phoneNumber,
        'userAddressLat':userAddressLat,
        'userAddressLng':userAddressLng,
        'id':uId
      };
  }
}