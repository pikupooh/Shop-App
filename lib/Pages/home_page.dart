import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Pages/profile_page.dart';
import 'package:shop_app/Services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Shop'),
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.settings,
                color: Theme.of(context).bottomAppBarColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            )
          ],
        ),
        body: Center(
          child: RaisedButton(
            child: Text(user.phone),
            onPressed: () {
              AuthServices().signOut();
            },
          ),
        ));
  }
}
