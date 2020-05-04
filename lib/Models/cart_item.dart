import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Models/product.dart';

class CartItem{
  String name;
  int quantity;
  String cost;
  String totalCost;

  CartItem({this.name, this.cost, this.quantity, this.totalCost});

  factory CartItem.fromProduct(Product product){
    return CartItem(
      name: product.name,
      cost: product.cost,
      quantity: 1,
      totalCost: product.cost
    );
    
  }
  
}