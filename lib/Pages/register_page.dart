import 'package:flutter/material.dart';
import 'package:shop_app/Services/auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool enterNumber = true;
  void changeView() {
    enterNumber = !enterNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: enterNumber ? _buildEnterNumber() : _buildenterOTP(),
    );
  }

  Widget _buildEnterNumber() {
    final _formKey = GlobalKey<FormState>();
    String phoneNumber = '';
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  prefixText: '+91',
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onSaved: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
              validator: (value) => value.length < 10 && value.isNotEmpty
                  ? 'Enter 10 digits number'
                  : null,
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton(
              child: Text('Send OTP'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    changeView();
                  });
                  print("phoneNumber" + phoneNumber);
                  AuthServices().verifyPhone("+91" + phoneNumber);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildenterOTP() {
    String otp = "";
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: "Enter OTP",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: (value) {
              setState(() {
                otp = value;
              });
            },
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            child: Text('Verify'),
            onPressed: () {
              // TODO verify otp
              AuthServices().signIn(otp);
            },
          ),
          FlatButton(
            child: Text('Back'),
            onPressed: () {
              setState(() {
                changeView();
              });
            },
          )
        ],
      ),
    );
  }
}
