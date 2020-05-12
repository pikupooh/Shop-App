import 'package:flutter/material.dart';

var kInputDecoration = InputDecoration(
  disabledBorder: kInputBorder,
  focusedBorder: kInputBorder,
  enabledBorder: kInputBorder,
  border: kInputBorder,
  hintText: "Enter OTP",
  fillColor: Colors.black12,
  filled: true,
);
Color kbackgroundColor = Color(0xFFF1F2F6);
Color kshadowColor = Color(0xFFDADFF0);
Color klightShadowColor = Colors.white;
Color ktextColor = Color(0xFF707070);
Color kseekBarLightColor = Color(0xFFB8ECED);
Color kseekBarDarkColor = Color(0xFF37C8DF);
var kSoftShadowDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(50),
  shape: BoxShape.rectangle,
  color: kbackgroundColor,
  boxShadow: [
    BoxShadow(color: kshadowColor, offset: Offset(8, 6), blurRadius: 12),
    BoxShadow(color: klightShadowColor, offset: Offset(-8, -6), blurRadius: 12),
  ],
);
var kInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: kbackgroundColor, width: 1));
