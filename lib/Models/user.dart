import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String phone;
  String address;
  String alternatePhoneNumber;
  String cartID;
  String name;
  String imageUrl;
  Map<dynamic, dynamic> orders;

  User({this.id, this.phone});

  factory User.fromfirebase(dynamic doc) {
    User user = new User(id: doc.documentID, phone: doc.data['phoneNumber']);
    user.name = doc.data["name"];
    user.address = doc.data["address"];
    user.cartID = doc.data['cartID'];
    user.alternatePhoneNumber = doc.data['alternatePhoneNumber'];
    user.imageUrl = doc.data['imageUrl'];
    user.orders = doc.data["orders"];
    return user;
  }
}
