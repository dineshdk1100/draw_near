import 'package:draw_near/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.grey,
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
            Navigator.of(context).push(MaterialPageRoute(builder: (c)=> BaseHome()));
          }
        });
    }, verificationFailed: (FirebaseAuthException e){
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
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/logoresize.png"),
          ),

          Container(
            margin: EdgeInsets.only(top: 20, left: 20,right: 20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  verifyPhoneNumber();
                },

                child: Text(
                  "  Verification code sent to this phone number : ${widget.codeDigits}-${widget.phone}",

                  style: TextStyle(fontFamily: 'Arial' ,fontWeight: FontWeight.bold, fontSize: 16),
                ),

              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(40.0),
            child: PinPut(
              fieldsCount : 6,
              textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinOTPCodeFocus,
              controller: _pinOTPCodeController,
              submittedFieldDecoration: pinOTPCodeDecoration,
              selectedFieldDecoration: pinOTPCodeDecoration,
              followingFieldDecoration: pinOTPCodeDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async{
                try{
                  await FirebaseAuth.instance.
                  signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationCode!, smsCode: pin))
                      .then((value){
                        if(value.user !=null)
                          {
                            Navigator.of(context).push(MaterialPageRoute(builder: (c)=> BaseHome()));
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
