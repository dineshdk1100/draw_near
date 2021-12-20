import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/screens/home.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'base-home.dart';
class OTPControllerScreen extends StatefulWidget {

  final String phone;
  final String codeDigits;

  OTPControllerScreen({required this.phone, required this.codeDigits});


  @override
  _OTPControllerScreenState createState() => _OTPControllerScreenState();
}

class _OTPControllerScreenState extends State<OTPControllerScreen> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController= TextEditingController();
  final FocusNode _pinOTPCodeFocus= FocusNode();

  String? verificationCode;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(
      color: Colors.black,

    )
  );

  @override
  void initState(){
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async{
    await FirebaseAuth.instance.verifyPhoneNumber(

    phoneNumber: "${widget.codeDigits + widget.phone}",
        verificationCompleted: (PhoneAuthCredential credential) async
    {
        await FirebaseAuth.instance.signInWithCredential(credential).then((value){
          if(value.user !=null)
          {
            Navigator.of(context).push(MaterialPageRoute(builder: (c)=> HomePage()));
          }
        });
    }, verificationFailed: (FirebaseAuthException e){
      print(e.message.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          duration: Duration(seconds: 3),
        ),
      );
    }, codeSent: (String vID, int? resentToken){
      setState(() {
        verificationCode = vID;

      });
    }, codeAutoRetrievalTimeout: (String vID ){
      setState(() {
        verificationCode = vID;
      });
    }, timeout: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("otp_verify".tr()),
        //backgroundColor: Colors.black,
      ),
      body : Column(


        children: [
          Padding(padding: const EdgeInsets.all(20.0),
          child: Image.asset("assets/images/logo_transparent.png",height: 180,),
          ),
          SizedBox(
           // width: 350,
            child: Padding(padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
          child: Text(
            "otp_text".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'San Francisco' ,color: Colors.pinkAccent,fontWeight: FontWeight.w600, fontSize: 16),
            //SizedBox(Icon(Icons.edit)
          ),)
          ),
          Container(

            margin: EdgeInsets.only(top: 10, left: 20,right: 20, bottom: 20),

            child: Center(
              child: GestureDetector(

                onTap: () {
                  verifyPhoneNumber();

                },

                child: Text(
                  " ${widget.codeDigits}-${widget.phone}   Resend OTP ",

                  style: TextStyle(decoration: TextDecoration.underline,fontStyle: FontStyle.italic, fontFamily: 'San Francisco' ,fontWeight: FontWeight.normal, fontSize: 14),
                  //SizedBox(Icon(Icons.edit))
                ),


              ),

            ),

          ),
          SizedBox(height: 10,),
          Text(
            "otp_digits".tr(),

            style: TextStyle(fontFamily: 'San Francisco' ,color: Colors.pinkAccent,fontWeight: FontWeight.w600, fontSize: 18),
            //SizedBox(Icon(Icons.edit))
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount : 6,
              textStyle: TextStyle(fontSize: 25.0, color: Colors.black),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinOTPCodeFocus,
              controller: _pinOTPCodeController,
              submittedFieldDecoration: pinOTPCodeDecoration,
              selectedFieldDecoration: pinOTPCodeDecoration,
              followingFieldDecoration: pinOTPCodeDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async{
                try{
                  await FirebaseAuth.instance.
                  signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationCode!, smsCode: pin))
                      .then((value){
                        if(value.user !=null)
                          {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (builder) => BaseHome()),
                                    (route) => false);
                          }
                  });
                }
                catch(e){
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid OTP"),
                        duration: Duration(seconds: 3),
                      ),
                  );
                }
              }
            ),
          ),
        ],
      )
    );
  }
}
