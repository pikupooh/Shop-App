import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Users').document(user.phone).snapshots(),
        builder: (context, snap){
          if(snap.hasData){
            User user = User.fromfirebase(snap.data);
            return _buildUserForm(user);
          }
          else return Text('Loading');
        },
      ),
    );
  }

  Widget _buildUserForm(User user){
    return Column(
      // TODO UI
      children: <Widget>[
        Container(
          height: 100,
          child:  Center(child: Text("Profile Image")),
        ),
        SizedBox(height: 10,),
        Text(user.name),
        Text(user.address),
        Text(user.alternatePhoneNumber),
        Text(user.phone)
      ],
    );
  }
}
