import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/order_item.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Pages/orderDetails.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/constants.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "My Orders",
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: kbackgroundColor,
        elevation: 0,
      ),
      body: Container(
        child: StreamBuilder(
          stream: DatabaseServices().getOrderItem(user),
          builder: (context, snap) {
            // print(snap.data);
            if (snap.hasData) {
              List<OrderItem> orderItems = snap.data;
              // print(orderItems.length);
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _buildOrderedList(orderItems),
              );
            } else
              return Center(child: Text("No Orders"));
          },
        ),
      ),
    );
  }

  Widget _buildOrderedList(List<OrderItem> orderItems) {
    // TODO UI
    return ListView(
      children: orderItems.map((order) => _buildEachOrder(order)).toList(),
    );
  }

  Widget _buildEachOrder(OrderItem order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Container(
        decoration: kSoftShadowDecoration.copyWith(
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: RichText(
                text: TextSpan(
                  text: 'OrderID:  ',
                  style: GoogleFonts.questrial(
                      color: Colors.black54, fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(
                        text: order.orderID,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 10)),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      order.status ?? "N/A",
                      style: TextStyle(
                          color: order.status == 'Delivered'
                              ? Colors.green
                              : order.status == 'Cancelled'
                                  ? Colors.red
                                  : Color(0xFF0013A8)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 13.0,left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Order Date:  ',
                              style:
                                  GoogleFonts.questrial(color: Colors.black54),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        "${order.orderDate.toDate().day}-${order.orderDate.toDate().month}-${order.orderDate.toDate().year}",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Order Total: ₹ ',
                              style:
                                  GoogleFonts.questrial(color: Colors.black54),
                              children: <TextSpan>[
                                TextSpan(
                                    text: order.totalCartCost,
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: RichText(
                            text: TextSpan(
                              text: 'Item Count: ',
                              style:
                                  GoogleFonts.questrial(color: Colors.black54),
                              children: <TextSpan>[
                                TextSpan(
                                  text: order.items.length.toString(),
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: kSoftShadowDecoration,
                      child: Provider<OrderItem>.value(
                        value: order,
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.forward,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => OrderDetails(
                                  orderItem: order,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
