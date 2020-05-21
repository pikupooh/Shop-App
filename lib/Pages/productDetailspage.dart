import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/product.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/reusables/constants.dart';

import 'cart_page.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({this.product});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  void _showToast(String name) {
    Fluttertoast.showToast(
        msg: "$name added to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      floatingActionButton: Container(
        decoration: kSoftShadowDecoration,
        child: !widget.product.outOfStock
            ? Buttons(
                onTap: () async {
                  DatabaseServices().addToCart(widget.product, user);
                  _showToast(widget.product.name);
                },
                iconColor: Colors.red,
                textColor: Colors.red,
                buttonColor: kbackgroundColor,
                text: "Add to Cart",
                icon: CupertinoIcons.add_circled_solid,
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 19),
                child: Text(
                  "Out of Stock",
                  style: TextStyle(fontSize: 20),
                ),
              ),
      ),
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          StreamBuilder(
              stream: DatabaseServices().getCartItems(user),
              builder: (context, snapshot) {
                return Container(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.shopping_cart,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => CartPage()));
                          },
                        ),
                      ),
                      Positioned(
                        top: 9,
                        right: 4,
                        child: Container(
                            child: Center(
                              child: Text(
                                snapshot.data != null
                                    ? snapshot.data.length.toString()
                                    : '0',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            )),
                      )
                    ],
                  ),
                );
              })
        ],
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: kbackgroundColor,
        elevation: 0,
        title: Text(
          "" ?? widget.product.name,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            decoration: kSoftShadowDecoration.copyWith(
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Hero(
                            tag: widget.product.imageurl,
                            child: CachedNetworkImage(
                              imageUrl: widget.product.imageurl,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.product.name,
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                              text: '₹ ',
                              style: TextStyle(color: Colors.redAccent),
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.product.cost,
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 29)),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.product.description,
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, top: 10),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Description",
                  //       style: TextStyle(fontSize: 15),
                  //     ),
                  //   ),
                  // ),
                  Divider(),
                  Text(
                    "lorem Ipsum",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
