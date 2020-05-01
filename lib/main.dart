import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Services/auth.dart';
import 'Models/user.dart';
import 'Pages/landing_page.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            //TODO theme
            ),
        home: LandingPage(),
      ),
    );
  }
}
