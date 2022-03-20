class ProductModel{
  late String productName;
  late String description;
  late String productUid;
  late String category;
  late String brandName;
  late String brandId;
  late double price;
  late double rate;
  late int offer;
  late List photos;
  late Map<String,dynamic> data;

 ProductModel({
   required this.productName,
   required this.description,
   required this.productUid,
   required this.category,
   required this.brandName,
   required this.price,
   required this.rate,
   required this.offer,
   required this.photos,
   required this.data,
 });

  ProductModel.fromJson(Map<String,dynamic>? json,String uid,String _brandName,String _brandId) {
    productName=json!['name'];
    description=json['description'];
    productUid=uid;
    category=json['category'];
    brandName= _brandName;
    brandId= _brandId;
    price=double.parse(json['price']);
    rate=json['rate']??1.2;
    offer=json['offer']!=''?double.parse(json['offer']).floor():0;
    photos=json['photos'];
    data =json['data'];
  }
}