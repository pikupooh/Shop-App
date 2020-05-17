import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/reusables/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    launch(
                        "https://sites.google.com/view/ajker-fresh/privacy-policy");
                  },
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  )),
              FlatButton(
                  onPressed: () {
                    launch(
                        "https://sites.google.com/view/ajker-fresh/terms-and-conditions");
                  },
                  child: Text(
                    "Terms of Use",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  )),
              FlatButton(
                  onPressed: () {
                    launch(
                        "https://sites.google.com/view/ajker-fresh/refund-policy");
                  },
                  child: Text(
                    "Refund Policy",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
