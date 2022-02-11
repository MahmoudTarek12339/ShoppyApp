class OrderModel{
  late String productName;
  late String description;
  late String productUid;
  late int quantity;
  late double price;
  late String photo;
  late String size;
  late String color;

  OrderModel({
    required this.productName,
    required this.description,
    required this.productUid,
    required this.quantity,
    required this.price,
    required this.photo,
    required this.size,
    required this.color,
  });

  OrderModel.fromJson(Map<String,dynamic>? json,String uid) {
    productName=json!['name'];
    description=json['description'];
    productUid=uid;
    quantity=json['quantity'];
    price=json['price'];
    photo=json['photo'];
    size=json['size'];
    color=json['color'];
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
      };
  }
}