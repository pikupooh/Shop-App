import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/order_item.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/database.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: StreamBuilder(
        stream: DatabaseServices().getOrderItem(user),
        builder: (context, snap) {
          // print(snap.data);
          if (snap.hasData) {
            List<OrderItem> orderItems = snap.data;
            // print(orderItems.length);
            return _buildOrderedList(orderItems);
          } else
            return Text("Loading");
        },
      )),
    );
  }

  Widget _buildOrderedList(List<OrderItem> orderItems) {
    // TODO UI
    return ListView(
      children: orderItems.map((order) => _buildEachOrder(order)).toList(),
    );
  }

  Widget _buildEachOrder(OrderItem order) {
    return Container(
      child: Text(order.items.toString()),
    );
  }
}
