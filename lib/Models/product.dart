import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String category, cost, description, imageurl, name;
  bool outOfStock;
  Product(
      {this.category,
      this.cost,
      this.description,
      this.imageurl,
      this.name,
      this.outOfStock});

  factory Product.fromFirebase(DocumentSnapshot doc) {
    Map data = doc.data;
    return Product(
      outOfStock: data['OutOfStock'],
      category: data['category'],
      cost: data['cost'],
      description: data['description'],
      imageurl: data['imageurl'],
      name: doc.documentID,
    );
  }
}
