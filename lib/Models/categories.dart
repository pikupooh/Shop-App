import 'package:cloud_firestore/cloud_firestore.dart';

class Category{
  String name ;
  Category({this.name});
  factory Category.fromFirebase(DocumentSnapshot doc){
    return Category(name: doc.data['category']) ;
  }
}