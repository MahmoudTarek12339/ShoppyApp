class UserModel{
  String? name;
  String? email;
  String? phone;
  String? image;
  String? uId;
  String? password;

  UserModel({this.name, this.email, this.phone, this.uId,this.image,this.password});

  UserModel.fromJson(Map<String,dynamic>? json) {
    name=json!['name'];
    email=json['email'];
    phone=json['phone'];
    image=json['image'];
    uId=json['uId'];
  }
  Map<String,dynamic> toMap(){
    return
      {'name':name,
        'email':email,
        'phone':phone,
        'uId':uId,
        'image':image,
      };
  }
}