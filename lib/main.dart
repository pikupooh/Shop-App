import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: "Ajker Fresh",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(textTheme: GoogleFonts.latoTextTheme()),
            textTheme: GoogleFonts.questrialTextTheme(),
            //TODO theme
            primaryColor: Color(0xFF0013A8)),
        home: LandingPage(),
      ),
    );
  }
}
