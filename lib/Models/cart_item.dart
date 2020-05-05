import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Models/product.dart';

class CartItem {
  String name;
  int quantity;
  String cost;
  String totalCost;

  CartItem({this.name, this.cost, this.quantity, this.totalCost});

  factory CartItem.fromProduct(Product product) {
    return CartItem(
        name: product.name,
        cost: product.cost,
        quantity: 1,
        totalCost: product.cost);
  }

  factory CartItem.fromMap(dynamic doc) {
    return CartItem(
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
      if(k != 'id')
        cartItems.add(CartItem.fromMap(v));
    });
    return cartItems;
  }
}
