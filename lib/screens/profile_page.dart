import 'package:draw_near/provider/google_sign_in.dart';
import 'package:draw_near/provider/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    final user= FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Information'),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () {
              final provider=Provider.of<LoginController>(context, listen :false);
              provider.logout();
            },
          )
        ],
      ),
      body: Container (
        alignment: Alignment.center,
        color: Colors.blueGrey.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile', style: TextStyle(fontSize:24),
            ),
            SizedBox(height : 32),
            CircleAvatar(radius: 40,
            backgroundImage: NetworkImage(user.photoURL!),
            ),
            SizedBox(height : 10),
            Text(
                'Name: ' + user.displayName!,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          SizedBox(height : 10),
            Text(
              'Email ID: ' + user.email!,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
