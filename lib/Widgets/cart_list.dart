import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/cart_item.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/database.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Container(
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
      children: snapshot
          .map((data) => _buildCaterogyListItem(context, data))
          .toList(),
    );
  }

  Widget _buildCaterogyListItem(BuildContext context, CartItem doc) {
    return Row(
      children: <Widget>[
        Image.network(doc.imageurl.toString(),fit: BoxFit.contain,),
        Text(doc.name.toString()),
        SizedBox(
          width: 30,
        ),
        Text(doc.quantity.toString()),
      ],
    );
  }
}
