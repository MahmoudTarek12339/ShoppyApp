
class BrandModel{
  late String brandName;
  late String brandImage;
  late String brandUId;



  BrandModel({
    required this.brandName,
    required this.brandImage,
    required this.brandUId,
  });

  BrandModel.fromJson(Map<String,dynamic>? json) {
    brandName=json!['brandName'];
    brandImage=json['image'];
    brandUId=json['uId'];
  }

 }