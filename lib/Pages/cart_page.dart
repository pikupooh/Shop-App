import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shop_app/Models/cart_item.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Pages/addressPage.dart';
import 'package:shop_app/Pages/orderConfirmationPage.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/Widgets/cart_list.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/reusables/constants.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double amount;

  final snackBar = SnackBar(
      duration: Duration(milliseconds: 300),
      elevation: 8,
      content: Text(
        'Cart is empty',
        style: GoogleFonts.questrial(),
      ));
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

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
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          decoration: kSoftShadowDecoration.copyWith(
                              borderRadius: BorderRadius.circular(50)),
                          child: Builder(
                            builder: (context) => Buttons(
                              textColor: Colors.red,
                              iconColor: Colors.red,
                              icon: Icons.clear_all ??
                                  CupertinoIcons.delete_simple ??
                                  Icons.delete_outline,
                              text: "Clear",
                              buttonColor: kbackgroundColor,
                              onTap: () {
                                DatabaseServices().createCart(user.phone);
                              },
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTotalCostText(user)),
                      Container(
                          decoration: kSoftShadowDecoration.copyWith(
                              borderRadius: BorderRadius.circular(50)),
                          child: Builder(
                            builder: (context) => Buttons(
                              textColor: Colors.green,
                              iconColor: Colors.green,
                              icon: CupertinoIcons.forward,
                              text: "Checkout",
                              buttonColor: kbackgroundColor,
                              onTap: () async {
                                amount == 0
                                    ? Scaffold.of(context)
                                        .showSnackBar(snackBar)
                                    : Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => AddressPage(
                                                  userPhone: user.phone,
                                                  amount: amount,
                                                ))); // bool status = await createOrder(user);
                                // status
                                //     ? openCheckout(amount, user)
                                //     : Scaffold.of(context).showSnackBar(snackBar);
                              },
                            ),
                          ))
                    ],
                  ),
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
          DatabaseServices().updateCart(user);
          if (snap.data.data == null) return Text("");

          this.amount =
              double.parse(snap.data.data['totalCartCost'].toString());

          return RichText(
            text: TextSpan(
                text: '',
                style: GoogleFonts.questrial(color: Colors.redAccent),
                children: <TextSpan>[
                  TextSpan(
                      text: '  ₹ ',
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

  // Future<bool> createOrder(User user) async {
  //   List<CartItem> cartItems = new List();
  //   await Firestore.instance
  //       .collection("Cart")
  //       .document(user.phone)
  //       .get()
  //       .then((onValue) {
  //     cartItems = CartItem().fromFirebase(onValue);
  //   });
  //   if (cartItems == null || cartItems.isEmpty || cartItems.length == 0) {
  //     print("not added");
  //     return false;
  //   }
  //   DatabaseServices().placeOrder(cartItems, user, 'test');
  //   return true;
  //   // DatabaseServices().createCart(user.phone);
  // }
}
