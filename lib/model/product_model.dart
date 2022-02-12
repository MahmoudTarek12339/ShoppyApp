class ProductModel{
  late String productName;
  late String description;
  late String productUid;
  late String category;
  late int quantity;
  late double price;
  late double rate;
  late double offer;
  late List photos;
  late List sizes;
  late List colors;

 ProductModel({
   required this.productName,
   required this.description,
   required this.productUid,
   required this.category,
   required this.quantity,
   required this.price,
   required this.rate,
   required this.offer,
   required this.photos,
   required this.sizes,
   required this.colors,
 });

  ProductModel.fromJson(Map<String,dynamic>? json,String uid) {
    productName=json!['name'];
    description=json['description'];
    productUid=uid;
    category=json['category'];
    quantity=json['quantity'];
    price=json['price'];
    rate=json['rate'];
    offer=json['offer'];
    photos=json['photos'];
    sizes=json['sizes'];
    colors=json['colors'];
  }
  Map<String,dynamic> toMap(){
    return
      {'name':productName,
        'description':description,
        'productUid':productUid,
        'quantity':quantity,
        'category':category,
        'price':price,
        'rate':rate,
        'offer':offer,
        'photos':photos,
        'sizes':sizes,
        'colors':colors,
      };
  }
}