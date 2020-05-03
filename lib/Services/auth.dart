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


  onAuthSuccess() async {
    print("suth success " + this.phoneNo);

    final snapShot = await Firestore.instance
        .collection('Users')
        .document(this.phoneNo)
        .get();

    if (snapShot == null || !snapShot.exists) {
      print("Does not exits");
      DatabaseServices().createUser(this.phoneNo);
    } else {
      print("Exits");
    }
  }

  signIn({AuthCredential authCredential, String name, String phoneNo}) async {
    print("On sign in " + phoneNo);
    AuthResult result = await _auth.signInWithCredential(authCredential);
    FirebaseUser user = result.user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    onAuthSuccess();
  }

  void signOut() {
    print("Logout call");
    _auth.signOut();
  }
}
