import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/Services/auth.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/reusables/constants.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

String phone, verificationID, smsCode, name;

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  bool smsSent = false;
  bool verComplete = false;
  bool readonly = false;
  bool sendingOtp = false;
  bool isConnected = true;

  void checkNetwok() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
       // print('connected');
      }
    } on SocketException catch (_) {
      setState(() {
        isConnected = false;
      });
     // print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    checkNetwok();
    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: verComplete
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xFF0013A8),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Container(child: Image.asset('assets/welcome.png')),
                  SizedBox(
                    height: 40,
                  ),
                  isConnected
                      ? Form(
                          key: formkey,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: <Widget>[
                                smsSent
                                    ? Container()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                smsSent
                                    ? Container()
                                    : TextFormField(
                                        decoration: kInputDecoration.copyWith(
                                            fillColor: Colors.grey[300],
                                            prefixIcon: Icon(Icons.phone),
                                            // prefixText: "+91-",
                                            hintText: "Phone"),
                                        keyboardType: TextInputType.phone,
                                        onChanged: (value) {
                                          setState(() {
                                            phone = "+91" + value;
                                          });
                                        },
                                        validator: (String value) {
                                          if (value.isEmpty ||
                                              value.length != 10)
                                            return "Enter 10 digits";
                                          return null;
                                        },
                                      ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: sendingOtp
                                      ? Container(
                                          child: Column(
                                            children: <Widget>[
                                              CircularProgressIndicator(
                                                backgroundColor:
                                                    Color(0xFF0013A8),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text("Sending OTP.")
                                            ],
                                          ),
                                        )
                                      : smsSent
                                          ? Container()
                                          : Container(
                                              decoration: kSoftShadowDecoration
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                              child: Buttons(
                                                icon: Icons.arrow_forward_ios,
                                                buttonColor: kbackgroundColor,
                                                text: "Send OTP",
                                                iconColor: Color(0xFF0013A8),
                                                textColor: Color(0xFF0013A8),
                                                onTap: () async {
                                                  if (formkey.currentState
                                                      .validate()) {
                                                    print(phone);
                                                    setState(() {
                                                      readonly = true;
                                                    });
                                                    await verifyPhone(phone);
                                                    setState(() {
                                                      sendingOtp = true;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                ),
                                smsSent
                                    ? TextFormField(
                                        textAlign: TextAlign.center,
                                        decoration: kInputDecoration.copyWith(
                                          fillColor: Colors.grey[300],
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            smsCode = value;
                                          });
                                        },
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                smsSent
                                    ? Container(
                                        decoration:
                                            kSoftShadowDecoration.copyWith(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                        child: Buttons(
                                          iconColor: Colors.black,
                                          textColor: Colors.black,
                                          icon: Icons.verified_user,
                                          buttonColor: kbackgroundColor,
                                          text: "Verify OTP",
                                          onTap: () {
                                            print(phone);
                                            AuthServices().signInOTP(smsCode,
                                                verificationID, name, phone);
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.warning,
                              size: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Please connect to internet to use the app."),
                            ),
                          ],
                        )),
                ],
              ),
            ),
    );
  }

  void _showToast() {
    Fluttertoast.showToast(
        msg: "OTP sent",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      setState(() {
        this.verComplete = true;
      });
      AuthServices()
          .signIn(authCredential: authResult, name: name, phoneNo: phone);
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print("${authException.message}");
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      _showToast();
      setState(() {
        this.smsSent = true;
        this.sendingOtp = false;
      });
      print(forceResend);

      verificationID = verId;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationID = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
