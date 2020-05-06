import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/Widgets/cart_list.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/reusables/constants.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
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
            "Cart",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
            ),
          )),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: CartList()),
            Container(
              color: kbackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildTotalCostText(user)),
                    Container(
                      decoration: kSoftShadowDecoration.copyWith(
                          borderRadius: BorderRadius.circular(50)),
                      child: Buttons(
                        textColor: Colors.red,
                        iconColor: Colors.red,
                        icon: CupertinoIcons.forward,
                        text: "Checkout",
                        buttonColor: kbackgroundColor,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCostText(User user) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("Cart")
          .document(user.phone)
          .snapshots(),
      builder: (context, snap) {
        if (snap.hasData) {
          //DatabaseServices().updateCart(user);
          if (snap.data.data == null) return Text("");
          return RichText(
            text: TextSpan(
                text: 'Total - ',
                style: GoogleFonts.questrial(color: Colors.redAccent),
                children: <TextSpan>[
                  TextSpan(
                      text: '  ₹',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 20)),
                  TextSpan(
                      text: snap.data.data['totalCartCost'].toString(),
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 29)),
                ]),
          );
        } else
          return Text("");
      },
    );
  }
}
