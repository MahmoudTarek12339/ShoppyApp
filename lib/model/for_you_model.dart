class ForYouModel {
  String? lastBrand;
  String? lastCategory;
  ForYouModel(this.lastBrand, this.lastCategory);

  ForYouModel.fromJson(Map<String, dynamic>? json) {
    lastBrand=json!['lastBrand'];
    lastCategory=json['lastCategory'];
  }
  Map<String,dynamic> toMap(){
    return{
      'lastBrand':lastBrand,
      'lastCategory':lastCategory
    };
  }
}