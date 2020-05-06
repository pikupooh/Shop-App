import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem{
  String userid;
  String totalCartCost;
  Map<String, int> items;

  OrderItem({this.userid, this.totalCartCost});

  factory OrderItem.fromFirebase(DocumentSnapshot doc){
    Map data = doc.data ;
    // print(data.toString());
    OrderItem orderItem = new OrderItem (userid: data['userid'], totalCartCost: data['totalCartCost']);
    orderItem.items = new Map<String, int>();
    data.forEach((key, value){
      if(key != 'userid' && key != 'totalCartCost'){
        // print(value);
        orderItem.items.addAll({"$key": value});
      }
    });
    // print(orderItem.items);
    return orderItem;
  }
}