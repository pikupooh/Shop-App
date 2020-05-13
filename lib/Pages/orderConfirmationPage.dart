import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Pages/home_page.dart';
import 'package:shop_app/reusables/constants.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/Pages/orders_page.dart';

class OrderConfirmation extends StatefulWidget {
  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  FlareController _controller;
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kbackgroundColor,
        title: Text(
          "Order Placed",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: FlareActor(
                "assets/Success.flr",
                animation: "success",
                controller: _controller,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Text(
              "Order Placed Successfully",
              style: TextStyle(fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: kSoftShadowDecoration,
              child: Buttons(
                icon: CupertinoIcons.forward,
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => OrdersPage()));
                },
                text: "Your Orders",
              ),
            ),
          ),
        ],
      )),
    );
  }
}
