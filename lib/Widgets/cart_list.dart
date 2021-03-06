import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/cart_item.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/constants.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Container(
      color: kbackgroundColor,
      child: StreamBuilder(
        stream: DatabaseServices().getCartItems(user),
        builder: (context, snap) {
          List<CartItem> cartItem = snap.data;
          if (snap.hasData && cartItem.length >= 1) {
            DatabaseServices().updateCart(user);
            return Stack(
              children: <Widget>[
                _buildCart(cartItem),
                isLoading
                    ? Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(child: CircularProgressIndicator()))
                    : Container()
              ],
            );
          }
          return Center(child: Text("Cart is empty"));
        },
      ),
    );
  }

  Widget _buildCart(List<CartItem> snapshot) {
    return ListView(
      padding: EdgeInsets.only(right: 20, left: 20, top: 10),
      // itemExtent: 180,
      children: snapshot
          .map((data) => _buildCaterogyListItem(context, data))
          .toList(),
    );
  }

  Widget _buildCaterogyListItem(BuildContext context, CartItem doc) {
    User user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: FittedBox(
        child: Container(
          decoration: BoxDecoration(
              color: kbackgroundColor,
              boxShadow: [
                BoxShadow(
                    color: kshadowColor, offset: Offset(8, 6), blurRadius: 12),
                BoxShadow(
                    color: klightShadowColor,
                    offset: Offset(-8, -6),
                    blurRadius: 12),
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: <Widget>[
              FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                      child: Container(
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            doc.imageurl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.minus_circled,
                              color: doc.quantity <= 1
                                  ? Colors.grey[300]
                                  : Colors.black,
                            ),
                            onPressed: doc.quantity <= 1
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await DatabaseServices()
                                        .changeCartItemQuantity(
                                            doc.name, user, false);
                                    setState(
                                      () {
                                        isLoading = false;
                                      },
                                    );
                                  },
                          ),
                          Text(
                            doc.quantity.toString(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                              enableFeedback: true,
                              icon: Icon(CupertinoIcons.add_circled),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await DatabaseServices().changeCartItemQuantity(
                                    doc.name, user, true);
                                setState(() {
                                  isLoading = false;
                                });
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            doc.name,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7, right: 8.0),
                            child: RichText(
                              text: TextSpan(
                                  text: '₹ ',
                                  style: TextStyle(color: Colors.black54),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: doc.totalCost,
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 20)),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: -7,
                right: -7,
                child: IconButton(
                    icon: Icon(CupertinoIcons.clear),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await DatabaseServices().deleteFromCart(doc.name, user);
                      DatabaseServices().updateCart(user);
                      setState(() {
                        isLoading = false;
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
