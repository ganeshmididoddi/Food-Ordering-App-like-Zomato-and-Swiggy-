import 'package:cloud_firestore/cloud_firestore.dart';

class Items
{
  String? menuID;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  int? price;
  String? status;


  Items({
    this.menuID,
    this.sellerUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.price,
    this.status,
});

  Items.fromJson(Map<String, dynamic> json)
  {
    menuID=json['menuID'];
    sellerUID=json['sellerUID'];
    itemID=json['itemID'];
    title=json['title'];
    shortInfo=json['shortInfo'];
    publishedDate=json['publishedDate'];
    thumbnailUrl=json['thumbnailUrl'];
    longDescription=json['longDescription'];
    price=json['price'];
    status=json['status'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['menuID']=menuID;
    data['sellerUID']=sellerUID;
    data['itemID']=itemID;
    data['title']=title;
    data['shortInfo']=shortInfo;
    data['price']=price;
    data['price']=price;
    data['thumbnailUrl']=thumbnailUrl;
    data['longDescription']=longDescription;
    data['status']=status;

    return data;

}


}

