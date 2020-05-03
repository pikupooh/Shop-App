import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  String category, cost, description, imageurl, name;
  Product({this.category, this.cost, this.description, this.imageurl, this.name}) ;

  factory Product.fromFirebase(DocumentSnapshot doc){
    Map data = doc.data;
    return Product(
      category: data['category'],
      cost: data['cost'],
      description: data['description'],
      imageurl: data['imageurl'],
      name: doc.documentID,
    ) ;
  }
}