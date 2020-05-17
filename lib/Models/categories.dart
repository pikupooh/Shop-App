import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  String imgUrl;
  Category({this.name, this.imgUrl});
  factory Category.fromFirebase(DocumentSnapshot doc) {
    return Category(name: doc.data['category'], imgUrl: doc.data['imgUrl']??"https://firebasestorage.googleapis.com/v0/b/shop-a-174a2.appspot.com/o/Categories%20Icon%2FAll.png?alt=media&token=b3e40ec2-7e41-4600-b854-6578982852a2");
  }
}
