import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/order_item.dart';
import 'package:shop_app/reusables/constants.dart';

class OrderDetails extends StatefulWidget {
  final OrderItem orderItem;
  OrderDetails({this.orderItem});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kbackgroundColor,
        title: Text(
          "Receipt",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            decoration: kSoftShadowDecoration.copyWith(
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      text: 'OrderID:  ',
                      style: GoogleFonts.questrial(
                          color: Colors.black54, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.orderItem.orderID,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black54,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Placed on :",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "${widget.orderItem.orderDate.toDate().day}-${widget.orderItem.orderDate.toDate().month}-${widget.orderItem.orderDate.toDate().year}",
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Delivered on :",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "Yet to be delivered",
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black54,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     "Items",
                //     style: TextStyle(fontSize: 22),
                //   ),
                // ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.orderItem.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = widget.orderItem.items.keys.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "$key ",
                                  style: GoogleFonts.questrial(
                                      color: Colors.black, fontSize: 20),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(" ${widget.orderItem.items[key]}",
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                          fontSize: 16)),
                                ),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  color: Colors.black54,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                  child: Container(
                    decoration: kSoftShadowDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20),
                      child: RichText(
                        text: TextSpan(
                          text: 'Order Total: ₹  ',
                          style: GoogleFonts.questrial(
                              color: Colors.green, fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                                text: widget.orderItem.totalCartCost,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 22)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
