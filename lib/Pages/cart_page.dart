import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';
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
    print(user.phone);
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
                      child: RichText(
                        text: TextSpan(
                            text: 'Total -',
                            style: TextStyle(color: Colors.black54),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " ₹ X,XXX",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 29)),
                            ]),
                      ),
                    ),
                    Buttons(
                      icon: CupertinoIcons.forward,
                      text: "Checkout",
                      buttonColor: Colors.orange,
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
}
