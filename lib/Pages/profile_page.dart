import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/auth.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/reusables/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name, alternatePhone, imageUrl, address;
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    //print(user);
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0,
        backgroundColor: kbackgroundColor,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: StreamBuilder(
        stream: DatabaseServices().streamUser(user),
        builder: (context, snap) {
          if (snap.hasData) {
            return _buildUserForm(snap.data);
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _showToast() {
    Fluttertoast.showToast(
        msg: "Profile Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  Widget _buildUserForm(User user) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Stack(fit: StackFit.loose, children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kbackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color: kshadowColor,
                              offset: Offset(8, 6),
                              blurRadius: 12),
                          BoxShadow(
                              color: klightShadowColor,
                              offset: Offset(-8, -6),
                              blurRadius: 12),
                        ],
                      ),
                      child: CircleAvatar(
                        child: Icon(
                          CupertinoIcons.person_solid,
                          color: Colors.black38,
                          size: 100,
                        ),
                        backgroundColor: kbackgroundColor ?? Colors.grey[200],
                        radius: 70,
                      ),
                    )
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 90.0, left: 100.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       CircleAvatar(
                //         backgroundColor: Colors.orange,
                //         radius: 25.0,
                //         child: Icon(
                //           CupertinoIcons.photo_camera,
                //           color: Colors.white,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: kSoftShadowDecoration.copyWith(
                  borderRadius: BorderRadius.circular(30)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty || value.length == 0 || value == 'None')
                      return "Enter your name";
                    return null;
                  },
                  initialValue: user.name,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: kInputDecoration.copyWith(
                    fillColor: kbackgroundColor,
                    prefixIcon: Icon(CupertinoIcons.person),
                    hintText: "Name",
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: kSoftShadowDecoration.copyWith(
                  borderRadius: BorderRadius.circular(30)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextField(
                  readOnly: true,
                  decoration: kInputDecoration.copyWith(
                      hintStyle: TextStyle(color: Colors.black),
                      fillColor: kbackgroundColor,
                      prefixIcon: Icon(CupertinoIcons.phone),
                      hintText: user.phone,
                      suffixIcon: Icon(Icons.lock_outline)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: kSoftShadowDecoration.copyWith(
                  borderRadius: BorderRadius.circular(30)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  initialValue: user.alternatePhoneNumber,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.length != 10) {
                      return 'Please enter a valid 10 digit number.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      alternatePhone = value;
                    });
                  },
                  decoration: kInputDecoration.copyWith(
                    fillColor: kbackgroundColor,
                    prefixIcon: Icon(CupertinoIcons.phone_solid),
                    hintText: "Alternate phone number",
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: kSoftShadowDecoration.copyWith(
                  borderRadius: BorderRadius.circular(30)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  initialValue: user.address,
                  validator: (value) {
                    if (value.isEmpty || value.length == 0 || value == 'None')
                      return "Enter proper address";
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  decoration: kInputDecoration.copyWith(
                    fillColor: kbackgroundColor,
                    prefixIcon: Icon(CupertinoIcons.location),
                    hintText: "Enter your address",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                shape: BoxShape.rectangle,
                color: kbackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: kshadowColor,
                      offset: Offset(8, 6),
                      blurRadius: 12),
                  BoxShadow(
                      color: klightShadowColor,
                      offset: Offset(-8, -6),
                      blurRadius: 12),
                ],
              ),
              child: Buttons(
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    await DatabaseServices().updateProfile(
                        user.phone,
                        name ?? user.name,
                        alternatePhone ?? user.alternatePhoneNumber,
                        imageUrl ?? user.imageUrl,
                        address ?? user.address);
                    _showToast();

                    print(name);
                  }
                },
                iconColor: Colors.green,
                textColor: Colors.green,
                buttonColor: kbackgroundColor,
                text: "Update Profile",
                icon: Icons.refresh,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                shape: BoxShape.rectangle,
                color: kbackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: kshadowColor,
                      offset: Offset(8, 6),
                      blurRadius: 12),
                  BoxShadow(
                      color: klightShadowColor,
                      offset: Offset(-8, -6),
                      blurRadius: 12),
                ],
              ),
              child: Buttons(
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
                buttonColor: kbackgroundColor ?? Colors.red,
                text: "Logout",
                icon: Icons.exit_to_app,
                onTap: () {
                  Navigator.pop(context);
                  AuthServices().signOut();
                },
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
