import 'package:flutter/material.dart';
import 'package:shop_app/Services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Logout'),
          onPressed: (){
            AuthServices().signOut();
          },
        ),
      )
    );
  }
}
