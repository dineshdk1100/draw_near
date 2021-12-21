import 'dart:async';

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:draw_near/services/download-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

class Initializer extends StatefulWidget {
  const Initializer({Key? key}) : super(key: key);

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  void initState() {
    // Timer(Duration(seconds: 4), () {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => LoginPage()));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(builder: (context, isConnected, status) {
      print(status.toString() + "s");
      if (isConnected == true) {
        DownloadService.instance
            .initialize()
            .then((value) {
              UserService.instance.isAppInitialized = true;
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));})
            .catchError((e) {
          print(e);
          Fluttertoast.showToast(msg: 'Something went wrong');
        });
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              children: [
                isConnected != true
                    ? Icon(
                        Icons.signal_wifi_off,
                        size: 120,
                        color: Theme.of(context).textTheme.caption?.color,
                      )
                    : Image.asset('assets/images/logo_transparent.png',
                        height: 150),
                SizedBox(
                  height: 32,
                ),
                Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isConnected != true
                          ? Text(
                              'You are Offline',
                              style: Theme.of(context).textTheme.headline6,
                            )
                          : Text(
                              'Initialising',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                      SizedBox(
                        width: 24,
                      ),
                      isConnected == true
                          ? CircularProgressIndicator.adaptive()
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                isConnected != true
                    ? Text(
                        'Please connect to the internet to prepare the app for first time use. Once this is done you can go offline.',
                        style: TextStyle(height: 1.4),
                        textAlign: TextAlign.center)
                    : Text(
                        'Please wait while we load the devotions for you...',
                        textAlign: TextAlign.center,
                      )
              ],
            )),
      );
    });
  }
}
