import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  String paymenetId;
  String status;
  String orderID;
  String userid;
  String totalCartCost;
  Map<String, int> items;
  Timestamp orderDate;
  String name;
  String address;
  String alternatePhone;
  String phone;
  Timestamp statusUpdatedOn;

  OrderItem(
      {this.userid,
      this.totalCartCost,
      this.orderID,
      this.orderDate,
      this.status,
      this.paymenetId,
      this.address,
      this.alternatePhone,
      this.name,
      this.phone,
      this.statusUpdatedOn});

  factory OrderItem.fromFirebase(DocumentSnapshot doc) {
    String orderID = doc.documentID;
    Map data = doc.data;
    // print(data.toString());
    OrderItem orderItem = new OrderItem(
      address: data['address'],
      name: data['name'],
      alternatePhone: data['alternatePhone'],
      phone: data['phone'],
      paymenetId: data['paymentId'],
      status: data['status'],
      orderDate: data['orderDate'],
      orderID: orderID,
      userid: data['userid'],
      totalCartCost: data['totalCartCost'],
      statusUpdatedOn: data['statusUpdatedOn'],
    );
    orderItem.items = new Map<String, int>();
    data.forEach((key, value) {
      if (key != 'userid' &&
          key != 'totalCartCost' &&
          key != 'orderDate' &&
          key != 'status' &&
          key != 'paymentId' &&
          key != 'name' &&
          key != 'address' &&
          key != 'alternatePhone' &&
          key != 'phone' &&
          key != 'statusUpdatedOn') {
        // print(value);
        orderItem.items.addAll({"$key": value});
      }
    });
    // print(orderItem.items);
    return orderItem;
  }
}
