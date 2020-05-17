import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Pages/cart_page.dart';
import 'package:shop_app/Pages/orders_page.dart';
import 'package:shop_app/Pages/profile_page.dart';
import 'package:shop_app/Services/database.dart';
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

  void _showToast() {
    Fluttertoast.showToast(
        backgroundColor: Colors.black12,
        msg: "This feature is not ready yet.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder(
        stream: DatabaseServices().getCartItems(user),
        builder: (context, snapshot) {
          return Scaffold(
            endDrawer: Drawer(),
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
                    CupertinoIcons.book,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => OrdersPage()));
                  },
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _showToast();

                    // Navigator.push(context,
                    //     CupertinoPageRoute(builder: (context) => CartPage()));
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
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10, bottom: 10),
                        child: Text(
                          "Quality",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Food & Groceries",
                          style: TextStyle(fontSize: 32),
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
                    SizedBox(height: 10),
                    CategoryList(
                      onTap: changeCategory,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
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
        });
  }
}
