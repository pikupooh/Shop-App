import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shop_app/Models/cart_item.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Pages/register_page.dart';

import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/reusables/constants.dart';

import 'orderConfirmationPage.dart';

class AddressPage extends StatefulWidget {
  final double amount;
  final String userPhone;
  AddressPage({this.amount, this.userPhone});
  @override
  _AddressPageState createState() => _AddressPageState();
}



class _AddressPageState extends State<AddressPage> {
  String name, alternatePhone, address;
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future openCheckout(double amount, User user) async {
    var options = {
      'key': 'rzp_test_GSlKWUbuUWCb8L',
      'amount': amount * 100,
      'name': 'Quality',
      'description': 'Food and Groceries',
      'prefill': {'contact': user.phone, 'email': 'test@razorpay.com'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await createOrder(widget.userPhone, response.paymentId, name, address,
        alternatePhone, phone);
    print("Name is");
    print(address);

    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => OrderConfirmation()));
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    //print(user);
    return Scaffold(
      floatingActionButton: Container(
        decoration: kSoftShadowDecoration,
        child: Buttons(
          onTap: () async {
            if (_formKey.currentState.validate()) {
              //_showToast();
              openCheckout(widget.amount, user);
            }
          },
          iconColor: Colors.green,
          textColor: Colors.green,
          buttonColor: kbackgroundColor,
          text: "Proceed to Payment",
          icon: Icons.attach_money ?? CupertinoIcons.double_music_note,
        ),
      ),
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
          'Review Order',
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
        msg: "Review Order",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  Widget _buildUserForm(User user) {
    name == null ? name = user.name : null;
    address == null ? address = user.address : null;
    alternatePhone == null ? alternatePhone = user.alternatePhoneNumber : null;
    phone = user.phone;

    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Deliver to",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: kSoftShadowDecoration.copyWith(
                      borderRadius: BorderRadius.circular(30)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty ||
                            value.length == 0 ||
                            value == 'None') return "Enter your name";
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
                SizedBox(height: 20),
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
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                Container(
                  decoration: kSoftShadowDecoration.copyWith(
                      borderRadius: BorderRadius.circular(30)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                      minLines: 2,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      initialValue: user.address,
                      validator: (value) {
                        if (value.isEmpty ||
                            value.length == 0 ||
                            value == 'None') return "Enter proper address";
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> createOrder(String userPhone, String paymentId, String name,
    String address, String alternatePhone, String phone) async {
  List<CartItem> cartItems = new List();
  await Firestore.instance
      .collection("Cart")
      .document(userPhone)
      .get()
      .then((onValue) {
    cartItems = CartItem().fromFirebase(onValue);
  });
  if (cartItems == null || cartItems.isEmpty || cartItems.length == 0) {
    print("not added");
    return false;
  }
  DatabaseServices().placeOrder(
      cartItems, userPhone, paymentId, name, address, alternatePhone, phone);
  return true;
}
