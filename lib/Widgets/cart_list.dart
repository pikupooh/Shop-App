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
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Container(
      color: kbackgroundColor,
      child: StreamBuilder(
        stream: DatabaseServices().getCartItems(user),
        builder: (context, snap) {
          List<CartItem> cartItem = snap.data;
          if (snap.hasData)
            return _buildCart(
                cartItem); //_buildCategoryList(snap.data.documents);
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCart(List<CartItem> snapshot) {
    return ListView(
      padding: EdgeInsets.only(right: 20, left: 20),
      itemExtent: 200,
      children: snapshot
          .map((data) => _buildCaterogyListItem(context, data))
          .toList(),
    );
  }

  Widget _buildCaterogyListItem(BuildContext context, CartItem doc) {
    return FittedBox(
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
            borderRadius: BorderRadius.circular(20)),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                child: Container(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
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
                        icon: doc.quantity <= 1
                            ? Icon(CupertinoIcons.delete)
                            : Icon(CupertinoIcons.minus_circled),
                        onPressed: () {}),
                    Text(
                      doc.quantity.toString(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        icon: Icon(CupertinoIcons.add_circled),
                        onPressed: () {}),
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, right: 8.0),
                      child: RichText(
                        text: TextSpan(
                            text: '₹ ',
                            style: TextStyle(color: Colors.redAccent),
                            children: <TextSpan>[
                              TextSpan(
                                  text: doc.totalCost,
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 29)),
                            ]),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
