import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  String paymenetId;
  String status;
  String orderID;
  String userid;
  String totalCartCost;
  Map<String, int> items;
  Timestamp orderDate;

  OrderItem(
      {this.userid,
      this.totalCartCost,
      this.orderID,
      this.orderDate,
      this.status,
      this.paymenetId});

  factory OrderItem.fromFirebase(DocumentSnapshot doc) {
    String orderID = doc.documentID;
    Map data = doc.data;
    // print(data.toString());
    OrderItem orderItem = new OrderItem(
        paymenetId: data['paymentId'],
        status: data['status'],
        orderDate: data['orderDate'],
        orderID: orderID,
        userid: data['userid'],
        totalCartCost: data['totalCartCost']);
    orderItem.items = new Map<String, int>();
    data.forEach((key, value) {
      if (key != 'userid' &&
          key != 'totalCartCost' &&
          key != 'orderDate' &&
          key != 'status' &&
          key != 'paymentId') {
        // print(value);
        orderItem.items.addAll({"$key": value});
      }
    });
    // print(orderItem.items);
    return orderItem;
  }
}
