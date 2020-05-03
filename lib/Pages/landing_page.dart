import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Pages/home_page.dart';
import 'package:shop_app/Pages/register_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null) return RegisterPage();
    else{
      return HomePage();
    }
  }
}
