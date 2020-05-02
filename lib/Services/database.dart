import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  final CollectionReference _doc = Firestore.instance.collection('Users');
  void createUser(String phoneNumber) async {
    await _doc.document(phoneNumber).setData({
      'address': "None",
      'phoneNumber': phoneNumber,
      'cartID': phoneNumber,
      'name': "Name",
      'alternatePhoneNumber': "Enter alternate phone number",
    });
  }
}