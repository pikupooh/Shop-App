import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/reusables/constants.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "About Us",
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: kbackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Image.asset('assets/logoTransparent.png'),
        ],
      ),
    );
  }
}
