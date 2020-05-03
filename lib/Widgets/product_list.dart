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

  Widget _buildProducts(){
    return StreamBuilder(
      stream: DatabaseServices().getProducts(),
      builder: (context, snap){
        List<Product> products = snap.data;
        if (snap.hasData) return _buildProductList(products); //_buildCategoryList(snap.data.documents);
          return Text("Loading");
      },
    ) ;
  }

  Widget _buildProductList(List<Product> snapshot) {
    return ListView(
      children: snapshot
          .map((data) => _buildProductListItem(context, data))
          .toList(),
    );
  }

  Widget _buildProductListItem(BuildContext context, Product doc) {
    return Container(
      height: 30, 
      width: 100,
      child: Stack(
        children: <Widget>[
          // TODO UI
          Positioned(
            height: 20,
            child: Text(doc.name),
          ),
        ],
      ));
  }
}