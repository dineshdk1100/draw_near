import 'package:draw_near/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.pinkAccent,
              Colors.white70,
              //Colors.red,
            ]
          )
        ),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Draw Near",style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10,),
                  Text("A Family Daily Devotion", style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height:20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children:<Widget>[
                        SizedBox(height: 60,),
                        Container(decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                            color: Color.fromRGBO(225, 90, 22, .3),
                            blurRadius: 20,
                            offset: Offset(0,10)
                          )]
                        ),
                        child: Column(
                         children:<Widget>[
                           ElevatedButton.icon(
                             style: ElevatedButton.styleFrom(
                               primary:Colors.white,
                               onPrimary: Colors.black,
                               minimumSize: Size(120, 50),
                             ),
                             icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                             label: Text('Sign In with Google'),
                             onPressed: (){
                               final provider= Provider.of<GoogleSignInProvider>(context, listen: false);
                               provider.googleLogin();
                             },
                           ),
                           //SizedBox(height: 20,),


                         ]
                        )
                        ),
                        SizedBox(height: 10,),
                        Container(decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                                color: Color.fromRGBO(225, 90, 22, .3),
                                blurRadius: 20,
                                offset: Offset(0,10)
                            )]
                        ),
                            child: Column(
                                children:<Widget>[
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary:Colors.white,
                                      onPrimary: Colors.black,
                                      minimumSize: Size(120, 50),
                                    ),
                                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                                    label: Text('Sign In with Google'),
                                    onPressed: (){
                                      final provider= Provider.of<GoogleSignInProvider>(context, listen: false);
                                      provider.googleLogin();
                                    },
                                  ),
                                  //SizedBox(height: 20,),


                                ]
                            )
                        ),
                        SizedBox(height: 40,),
                        //Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
                        SizedBox(height: 40,),

                       Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.pinkAccent
                          ),
                          child: Center(
                           // child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                        SizedBox(height: 50,),
                        Text(" Continue with Phone Number", style: TextStyle(color: Colors.grey),),

                      ]
                    )
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}