// import 'package:flutter/material.dart';
// import 'package:shop_app/Services/auth.dart';

// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   bool enterNumber = true;
//   void changeView() {
//     enterNumber = !enterNumber;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Register"),
//       ),
//       body: enterNumber ? _buildEnterNumber() : _buildenterOTP(),
//     );
//   }

//   Widget _buildEnterNumber() {
//     final _formKey = GlobalKey<FormState>();
//     String phoneNumber = '';
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: <Widget>[
//             TextFormField(
//               decoration: InputDecoration(
//                   prefixText: '+91',
//                   hintText: 'Enter your phone number',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   )),
//               onSaved: (value) {
//                 setState(() {
//                   phoneNumber = value;
//                 });
//               },
//               validator: (value) => value.length < 10 && value.isNotEmpty
//                   ? 'Enter 10 digits number'
//                   : null,
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             FlatButton(
//               child: Text('Send OTP'),
//               onPressed: () async {
//                 if (_formKey.currentState.validate()) {
//                   _formKey.currentState.save();
//                   setState(() {
//                     changeView();
//                   });
//                   print("phoneNumber" + phoneNumber);
//                   AuthServices().verifyPhone("+91" + phoneNumber);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildenterOTP() {
//     String otp = "";
//     return Container(
//       child: Column(
//         children: <Widget>[
//           TextField(
//             decoration: InputDecoration(
//               hintText: "Enter OTP",
//               border:
//                   OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 otp = value;
//               });
//             },
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           FlatButton(
//             child: Text('Verify'),
//             onPressed: () {
//               // TODO verify otp
//               AuthServices().signIn(otp);
//             },
//           ),
//           FlatButton(
//             child: Text('Back'),
//             onPressed: () {
//               setState(() {
//                 changeView();
//               });
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/Services/auth.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/reusables/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          smsSent
                              ? Container()
                              : TextFormField(
                                  decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(Icons.person),
                                      hintText: "Name"),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                ),
                          smsSent
                              ? Container()
                              : SizedBox(
                                  height: 10,
                                ),
                          smsSent
                              ? Container()
                              : TextFormField(
                                  decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(Icons.phone),
                                      // prefixText: "+91-",
                                      hintText: "Phone"),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    setState(() {
                                      phone = "+91" + value;
                                    });
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
                                          backgroundColor: Color(0xFF0013A8),
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
                                    : Buttons(
                                        icon: Icons.arrow_forward_ios,
                                        buttonColor: Color(0xFF0013A8) ??
                                            Colors.black ??
                                            Color(0xEE075E55),
                                        text: "Send OTP",
                                        onTap: () async {
                                          print(phone);
                                          setState(() {
                                            readonly = true;
                                          });
                                          await verifyPhone(phone);
                                          setState(() {
                                            sendingOtp = true;
                                          });
                                        },
                                      ),
                          ),
                          smsSent
                              ? TextFormField(
                                  textAlign: TextAlign.center,
                                  decoration: kInputDecoration,
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
                              ? Buttons(
                                  icon: Icons.verified_user,
                                  buttonColor:
                                      Colors.black ?? Color(0xEE075E55),
                                  text: "Verify OTP",
                                  onTap: () {
                                    print(phone);
                                    AuthServices().signInOTP(
                                        smsCode, verificationID, name, phone);
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
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
