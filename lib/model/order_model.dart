class OrderModel{
  late String productName;
  late String description;
  late String productUid;
  late int quantity;
  late double price;
  late String photo;
  late String size;
  late String color;
  late String brandId;
  late String cartId;
  OrderModel({
    required this.productName,
    required this.description,
    required this.productUid,
    required this.quantity,
    required this.price,
    required this.photo,
    required this.size,
    required this.color,
    required this.brandId,
  });

  void setUid(String id){
    this.cartId=id;
  }

  OrderModel.fromJson(Map<String,dynamic>? json) {
    productName=json!['name'];
    description=json['description'];
    productUid=json['productUid'];
    quantity=json['quantity'];
    price=json['price'];
    photo=json['photo'];
    size=json['size'];
    color=json['color'];
    brandId=json['brandId'];
  }

  Map<String,dynamic> toMap(){
    return
      {'name':productName,
        'description':description,
        'productUid':productUid,
        'quantity':quantity,
        'price':price,
        'photo':photo,
        'size':size,
        'color':color,
        'brandId':brandId,
      };
  }
}