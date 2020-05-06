import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Models/product.dart';

class CartItem {
  String name;
  int quantity;
  String cost;
  String totalCost;
  String imageurl;

  CartItem({this.name, this.cost, this.quantity, this.totalCost, this.imageurl});

  factory CartItem.fromProduct(Product product) {
    return CartItem(
        imageurl: product.imageurl,
        name: product.name,
        cost: product.cost,
        quantity: 1,
        totalCost: product.cost);
  }

  factory CartItem.fromMap(dynamic doc) {
    return CartItem(
      imageurl: doc['imageurl'],
      name: doc['name'],
      cost: doc['cost'],
      quantity: doc['quantity'],
      totalCost: doc['totalCost'],
    );
  }

  List<CartItem> fromFirebase(DocumentSnapshot doc) {
    var data = doc.data;
    List<CartItem> cartItems = new List();
    data.forEach((k, v) {
      if (k != 'id' && k != 'totalCartCost') cartItems.add(CartItem.fromMap(v));
    });
    return cartItems;
  }
}
