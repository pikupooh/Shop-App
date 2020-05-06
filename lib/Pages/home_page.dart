import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Pages/cart_page.dart';
import 'package:shop_app/Pages/profile_page.dart';
import 'package:shop_app/Widgets/category_list.dart';
import 'package:shop_app/Widgets/product_list.dart';
import 'package:shop_app/reusables/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentCategory = "all";
  void changeCategory(String cat) {
    setState(() {
      currentCategory = cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.ellipsis,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
        ),

        backgroundColor: kbackgroundColor ??
            Colors.grey[100] ??
            Color.fromRGBO(0, 0, 500, 0.3),
        //  title: Text('Shop'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => CartPage()));
            },
          ),
          Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.shopping_cart,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => CartPage()));
                    },
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 30,
                  child: Container(
                      height: 10,
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      )),
                )
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kbackgroundColor ?? Colors.grey[100],
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                  child: Text(
                    "Quality",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Food & Groceries",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: <Widget>[
              //     // SizedBox(
              //     //   width: 30,
              //     // ),
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width / 1.3,
              //       child: TextField(
              //         textAlign: TextAlign.center,
              //         decoration: kInputDecoration.copyWith(
              //           alignLabelWithHint: true,
              //           hintText: "Search",
              //           fillColor: Colors.white,
              //         ),
              //       ),
              //     ),
              //     Material(
              //       shape: CircleBorder(),
              //       elevation: 10,
              //       child: Container(
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: Colors.orangeAccent,
              //         ),
              //         child: IconButton(
              //             icon: Icon(
              //               CupertinoIcons.search,
              //               color: Colors.white,
              //             ),
              //             onPressed: () {}),
              //       ),
              //     ),
              //     // SizedBox(width: 5)
              //   ],
              // ),

              CategoryList(
                onTap: changeCategory,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: ProductList(
                  currentCategory: currentCategory,
                ),
              ),
              // SizedBox(
              //   height: 30,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
