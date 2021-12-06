/**import 'package:draw_near/screens/login.dart';
import 'package:draw_near/screens/onboarding.dart';
import 'package:draw_near/screens/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget{
  @override
  Widget build (BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasData) {
          return ProfilePage();
        } else if (snapshot.hasError){
          return Center(child: Text('Something went Wrong!'));
        }else{
          return LoginPage();
        }
      },
    ),
  );
}
    **/