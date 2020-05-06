import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                          child: _buildTotalCostText(user)
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
    
      Widget _buildTotalCostText(User user){
        return StreamBuilder(
          stream: Firestore.instance.collection("Cart").document(user.phone).snapshots(),
          builder: (context, snap){
            if(snap.hasData)
            {
              //DatabaseServices().updateCart(user);
              if(snap.data.data == null) return Text("");
              return Text(snap.data.data['totalCartCost'].toString());
            }
            else return Text("");
          },
        );
      }
    }
