import 'package:flutter/material.dart';
import 'package:shop_app/Models/product.dart';
import 'package:shop_app/Services/database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
        if (snap.hasData) {
          return GridView.builder(
         
              itemCount: products.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1/1.3),
              itemBuilder: (context, index) {
                return _gridViewItem(context, index, products);
              });
        }
        // _buildProductList(products);
        return Text("Loading");
      },
    );
  }

  Widget _gridViewItem(
      BuildContext context, int index, List<Product> products) {
    Product product = products[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
     
          decoration: BoxDecoration(
              color: Color(0x33d1dff7), borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      product.imageurl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      product.name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    )),
              ),
              Text("1 Kg.")
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildProductList(List<Product> snapshot) {
  //   return Container(
  //     height: 305,
  //     child: ListView(
  //       children: snapshot
  //           .map((data) => _buildProductListItem(context, data))
  //           .toList(),
  //     ),
  //   );
  // }

  // Widget _buildProductListItem(BuildContext context, Product doc) {
  //   // TODO UI
  //   return Text(doc.name);
  // }
}
