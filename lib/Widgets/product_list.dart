import 'package:flutter/material.dart';
import 'package:shop_app/Models/product.dart';
import 'package:shop_app/Services/database.dart';

class ProductList extends StatefulWidget {
  final String currentCategory;
  ProductList({this.currentCategory = "all"});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return _buildProducts();
  }

  Widget _buildProducts() {
    return StreamBuilder(
      stream: DatabaseServices().getProducts(widget.currentCategory),
      builder: (context, AsyncSnapshot<dynamic> snap) {
        List<Product> products = snap.data;
        if (snap.hasData) return _buildProductList(products);
        return Text("Loading");
      },
    );
  }

  Widget _buildProductList(List<Product> snapshot) {
    return Container(
      height: 305,
      child: ListView(
        children: snapshot
            .map((data) => _buildProductListItem(context, data))
            .toList(),
      ),
    );
  }

  Widget _buildProductListItem(BuildContext context, Product doc) {
    // TODO UI
    return Text(doc.name);
  }
}
