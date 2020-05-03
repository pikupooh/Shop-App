import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Colors.white,
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
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),

          backgroundColor: Colors.grey[100] ?? Color.fromRGBO(0, 0, 500, 0.3),
          //  title: Text('Shop'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CupertinoIcons.shopping_cart,
                color: Colors.black,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          color: Colors.grey[100],
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
                  padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                  child: Text(
                    "Food & Groceries",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: TextField(
                      decoration: kInputDecoration.copyWith(
                        hintText: "Search",
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Material(
                    shape: CircleBorder(),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orangeAccent,
                      ),
                      child: IconButton(
                          icon: Icon(
                            CupertinoIcons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                    ),
                  ),
                  SizedBox(width: 5)
                ],
              ),
              SizedBox(height: 20),
              CategoryList(
                onTap: changeCategory,
              ),
              Text(currentCategory),
              SizedBox(height: 20),

              Expanded(
                  child: ProductList(
                currentCategory: currentCategory,
              )),
              Center(
                child: RaisedButton(
                  child: Text(user.phone),
                  onPressed: () {
                    AuthServices().signOut();
                  },
                ),
              ),

              ProductList(currentCategory: currentCategory,),
              SizedBox(height: 30,),>>>>>>> master
            ],
          ),
        ));
  }
}
