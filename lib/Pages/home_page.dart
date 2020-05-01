import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';
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
        body: Center(
      child: RaisedButton(
        child: Text(user.id),
        onPressed: () {
          AuthServices().signOut();
        },
      ),
    ));
  }
}
