import 'dart:io' show Directory, File, Platform;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:draw_near/provider/login_controller.dart';
import 'package:draw_near/screens/OTPController.dart';
import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/screens/initializer.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:draw_near/util/offline-alert.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ScreenLoader {
  String dialCodeDigits = "+91";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loadableWidget(
      child: Scaffold(
        body: loginUI(),
      ),
    );
  }

  loginControllers(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          // Colors.blue.shade100,
          Color(pastelThemePrimaryValue),
          //Color(pastelThemePrimaryValue),
          //  Color(pastelThemePrimaryValue),

          Colors.white,
          //Colors.red,
        ])),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              "assets/images/logo_transparent.png",
              height: 160,
            ),
          ),
          /*Padding(
              padding: EdgeInsets.all(20),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Draw Near",style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10,),
                  Text("A Family Daily Devotion", style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),*/
          SizedBox(height: 20),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(children: <Widget>[
                            Text(
                              'login'.tr(),
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                child: Column(
                              children: [
                                SignInButton(
                                  Buttons.GoogleDark,
                                  text: ('sign_in_google'.tr()),
                                  onPressed: () async {
                                    if (await isUserOffline(context)) return;

                                    performFuture(Provider.of<LoginController>(
                                            context,
                                            listen: false)
                                        .googleLogin);
                                  },
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 5,
                            ),
                            Platform.isIOS
                                ? Container(
                                    child: Column(
                                      children: [
                                        SignInButton(
                                          Buttons.AppleDark,
                                          //padding: EdgeInsets.all(8.0),
                                          text: 'sign_in_apple'.tr(),
                                          onPressed: () async {
                                            if (await isUserOffline(context))
                                              return;
                                            performFuture(
                                                Provider.of<LoginController>(
                                                        context,
                                                        listen: false)
                                                    .signInWithApple);
                                          },
                                        ),
                                        //SizedBox(height: 20,),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Column(children: [
                                SignInButton(
                                  Buttons.Facebook,
                                  text: 'sign_in_facebook'.tr(),
                                  //padding: EdgeInsets.all(6.0),
                                  onPressed: () async {
                                    if (await isUserOffline(context)) return;
                                    performFuture(Provider.of<LoginController>(
                                            context,
                                            listen: false)
                                        .facebooklogin);
                                  },
                                ),
                                //SizedBox(height: 20,),
                              ]),
                            ),
                            SizedBox(height: 5),
                            Container(
                              // margin: EdgeInsets.all(5),
                              width: 220,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  //primary: Colors.blue.shade100, // background
                                  // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  UserService.instance.isGuest = true;
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => Initializer(true)));
                                },
                                child: Text(
                                  'continue_as_guest'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'San Francisco',
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            //Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
                            Text(
                              "or".tr(),
                              style: TextStyle(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            //SizedBox(height: 50,),
                            Text(
                              "phone_number".tr(),
                              style: TextStyle(),
                            ),
                            SizedBox(
                              width: 400,
                              height: 55,
                              child: CountryCodePicker(
                                dialogBackgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                onChanged: (country) {
                                  setState(() {
                                    dialCodeDigits = country.dialCode!;
                                  });
                                },
                                initialSelection: "IN",
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                favorite: ["+91", "IN", "+1", "US"],
                              ),
                            ),

                            Container(
                              //height: 50,
                              margin:
                                  EdgeInsets.only(top: 0, right: 10, left: 10),
                              //color: Color(0xff1d1d1d),
                              // borderRadius: BorderRadius.circular(15),

                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "phone_hint".tr(),
                                    prefix: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text(dialCodeDigits),
                                    )),

                                keyboardType: TextInputType.phone,
                                //validator: validateMobile,

                                controller: _controller,
                              ),
                            ),

                            Container(
                                margin: EdgeInsets.all(15),
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    //primary: Colors.blue.shade100, // background
                                    primary: Color(
                                        pastelThemePrimaryValue), // background
                                    onPrimary: Colors.white, // foreground
                                  ),

                                  onPressed: () {
                                    if (!validateMobile(_controller.text)) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please enter valid mobile number');
                                      return;
                                    }

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (c) => OTPControllerScreen(
                                                  phone: _controller.text,
                                                  codeDigits: dialCodeDigits,
                                                )));
                                    // }
                                  },

                                  //child: Text('Verify',style: TextStyle(fontFamily: 'San Francisco',color: Colors.black,fontWeight: FontWeight.bold),),
                                  child: Text(
                                    'Verify',
                                    style: TextStyle(
                                        fontFamily: 'San Francisco',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ))
                          ])))))
        ]));
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

  loginUI() {
    return Consumer<LoginController>(

        //var authStateChanges = FirebaseAuth.instance.authStateChanges();
        builder: (context, models, child) {
      if (models.userDetails != null) {
        return Center(
          child: UserService.instance.isCurrentLangDownloaded()
              ? BaseHome()
              : Initializer(true),
        );
      } else {
        return loginControllers(context);
      }
      return Container();
    });
  }

  loggedInUI(LoginController model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      // our ui will have 3 children, name, email, photo , logout button

      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(model.userDetails?.photoURL ?? "").image,
          radius: 50,
        ),

        Text(model.userDetails?.displayName ?? ""),
        Text(model.userDetails?.email ?? ""),

        // logout
        ActionChip(
            avatar: Icon(Icons.logout),
            label: Text("Logout"),
            onPressed: () {
              Provider.of<LoginController>(context, listen: false).logout();
            })
      ],
    );
  }
}
