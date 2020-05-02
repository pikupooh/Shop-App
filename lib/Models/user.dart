import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String id;
  String phone;
  String address;
  String alternatePhoneNumber;
  String cartID;
  String name;

  User({this.id, this.phone});

  factory User.fromfirebase(DocumentSnapshot doc){
    User user = new User(id: doc.documentID, phone: doc.data['phoneNumber']);
    user.name = doc.data["name"];
    user.address = doc.data["address"];
    user.cartID = doc.data['cartID'];
    user.alternatePhoneNumber = doc.data['alternatePhoneNumber'];
    return user;
  }
}