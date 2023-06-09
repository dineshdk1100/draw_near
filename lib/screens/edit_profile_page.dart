import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<ProfilePage> {
  var user = UserService.instance.userDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("profile_info".tr()),
        ),
        body:
            profileView() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget profileView() {
    return SingleChildScrollView(
      child: Column(

      children: <Widget>[
        SizedBox(height: 50),
        Container(
          child:  Text("profile_information".tr(), style: GoogleFonts.gentiumBasic(fontSize: 30),textAlign: TextAlign.left,),

        ),
        //Padding(padding:EdgeInsets.all(30),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Full Name'),
                    initialValue: user.displayName,
                    onChanged: (name) {
                      //print(name);
                      user.displayName = name;
                    },
                  ),
                ),

                //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, )),
                SizedBox(height: 15),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Email'),
                    initialValue: user.email ?? "",
                    onChanged: (email) {
                      user.email = email;
                    },
                  ),
                ),

                SizedBox(height: 15),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Phone Number'),
                    initialValue: user.phoneNumber ?? "",
                    onChanged: (phone) {
                      user.phoneNumber = phone;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.all(15),
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //primary: Colors.blue.shade100, // background
                        primary: Color(pastelThemePrimaryValue), // background
                        onPrimary: Colors.white, // foreground
                      ),

                      onPressed: () async {
                        if (!validateMobile(user.phoneNumber ?? "")) {
                          Fluttertoast.showToast(
                              msg:
                              'Please enter valid mobile number');
                          return;
                        }
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .set(user.toJson());
                        UserService.instance.userDetails = user;
                        Navigator.pop(context);
                        // }
                      },

                      //child: Text('Verify',style: TextStyle(fontFamily: 'San Francisco',color: Colors.black,fontWeight: FontWeight.bold),),
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }
  bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{5,16}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
