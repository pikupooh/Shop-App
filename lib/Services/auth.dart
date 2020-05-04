import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/database.dart';

class AuthServices {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  signInOTP(smsCode, verId, name, phoneNo) {
    this.phoneNo = phoneNo;
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);

    signIn(authCredential: authCredential, name: name, phoneNo: phoneNo);
  }

  User _fromFirebaseUser(FirebaseUser user) {
    return (user == null) ? null : User(id: user.uid, phone: user.phoneNumber);
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_fromFirebaseUser);
  }

  onAuthSuccess(String phoneNumber) async {
    print("suth success " + this.phoneNo);

    final usersnapShot = await Firestore.instance
        .collection('Users')
        .document(phoneNumber)
        .get();

    if (usersnapShot == null || !usersnapShot.exists) {
      print("Does not exits");
      DatabaseServices().createUser(phoneNumber);
    } else {
      print("Exits");
    }

    final cartsnapShot = await Firestore.instance
        .collection('Cart')
        .document(phoneNumber)
        .get();
    
    if (cartsnapShot == null || !cartsnapShot.exists) {
      print("Cart Does not exits");
      DatabaseServices().createCart(phoneNumber);
    } else {
      print("Cart Exits");
    }
  }

  signIn({AuthCredential authCredential, String name, String phoneNo}) async {
    print("On sign in " + phoneNo);
    AuthResult result = await _auth.signInWithCredential(authCredential);
    FirebaseUser user = result.user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    onAuthSuccess(phoneNo);
  }

  void signOut() {
    print("Logout call");
    _auth.signOut();
  }
}
