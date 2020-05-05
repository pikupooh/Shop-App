import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/product.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/constants.dart';

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
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1 / 1.5),
              itemBuilder: (context, index) {
                return _gridViewItem(context, index, products);
              });
        }
        // _buildProductList(products);
        return CircularProgressIndicator();
      },
    );
  }

  Widget _gridViewItem(
      BuildContext context, int index, List<Product> products) {
    Product product = products[index];
    User user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.all(9.0),
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
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
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
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "1 Kg.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 5),
                      child: RichText(
                        text: TextSpan(
                            text: '₹ ',
                            style: TextStyle(color: Colors.redAccent),
                            children: <TextSpan>[
                              TextSpan(
                                  text: product.cost,
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 29)),
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: IconButton(
                            icon: Icon(
                              CupertinoIcons.add,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              DatabaseServices().addToCart(product, user);
                            }),
                      ),
                    ),
                  )
                ],
              )
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
