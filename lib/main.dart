import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CartObject> cart = new List<CartObject>();
  bool cartViewPage = false;
  String appBarText = 'Shop';
  void cartToogle() {
    cartViewPage = !cartViewPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarText),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search, color: Colors.white), onPressed: null),
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (cartViewPage == false && cart.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Cart is Empty", gravity: ToastGravity.BOTTOM);
                  } else
                    setState(() {
                      cartViewPage = !cartViewPage;
                    });
                })
          ],
        ),
        body: _build(context));
  }

  Widget _build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Shop').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return _buildProducts(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildProducts(BuildContext context, List<DocumentSnapshot> snapshot) {
    print(cartViewPage.toString());
    return cartViewPage
        ? ListView(
            children:
                snapshot.map((data) => _buildCartItem(context, data)).toList(),
          )
        : ListView(
            children: snapshot
                .map((data) => _buildProductsList(context, data))
                .toList(),
          );
  }

  Widget _buildProductsList(BuildContext context, DocumentSnapshot doc) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Row(
        children: <Widget>[
          Container(
              width: 60.0,
              height: 60.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill, image: new NetworkImage(doc['imageurl'])),
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  doc.documentID.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  "Rs." + doc['cost'].toString(),
                  style: TextStyle(color: Colors.green),
                )
              ],
            )),
          ),
          Text(
            "Left: " + doc['left'].toString(),
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
              onPressed: () {
                if (doc['left'] > 0) {
                  int i;
                  for (i = 0; i < cart.length; i++) {
                    if (cart[i].name == doc.documentID.toString()) {
                      cart[i].increaseCount();
                      break;
                    }
                  }
                  if (i >= cart.length) {
                    cart.add(new CartObject(doc.documentID.toString()));
                  }
                  for (i = 0; i < cart.length; i++) {
                    print(cart[i].name + cart[i].count.toString());
                  }
                  doc.reference.updateData({'left': doc['left'] - 1});
                }
              }),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, DocumentSnapshot doc) {
    int flag = 0;
    int i;
    for (i = 0; i < cart.length; i++) {
      if (doc.documentID.toString() == cart[i].name.toString()) {
        flag = 1;
        break;
      }
    }
    return flag == 1
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Row(
              children: <Widget>[
                Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(doc['imageurl'])),
                    )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        doc.documentID.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(
                        "Rs." + doc['cost'].toString(),
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  )),
                ),
                Text(
                  "Items: " + cart[i].count.toString(),
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    icon: Icon(
                      Icons.do_not_disturb_on,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
                    onPressed: () {
                      cart[i].decreseCount();
                      if (cart[i].count == 0) {
                        cart.removeAt(i);
                      }
                      if(cart.isEmpty){
                        Fluttertoast.showToast(msg: "Car is Empty");
                        setState(() {
                          cartViewPage =false;
                        });
                      }
                      for (i = 0; i < cart.length; i++) {
                        print(cart[i].name + cart[i].count.toString());
                      }
                      doc.reference.updateData({'left': doc['left'] + 1});
                    }),
              ],
            ),
          )
        : Container();
  }
}

class CartObject {
  String name;
  int count;

  CartObject(String name) {
    this.name = name;
    count = 1;
  }

  void increaseCount() {
    count++;
  }

  void decreseCount() {
    count--;
  }
}
