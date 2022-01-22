import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/services/download-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//
class Initializer extends StatefulWidget {
  final bool firstTime;
  const Initializer(this.firstTime);

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(builder: (context, isConnected, status) {
      if (isConnected != null && isConnected == true) initializer();
      print(status.toString() + "s");
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
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
        ),
      );
    });
  }

  void initializer() async {
    int count =
        await DownloadService.instance.initialize(loadInBackground: false);
    print(count);
    Future.delayed(Duration(seconds: 10), () {
      UserService.instance
          .modifyDownloadedLangMap(UserService.instance.locale, true);
      if (widget.firstTime)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BaseHome()));
      else
        Navigator.pop(context);
    });
  }
}

// showInitializer(context) async {
//
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return WillPopScope(
//           onWillPop: () => Future.value(false),
//           child: AlertDialog(
//             content: new SingleChildScrollView(
//               child: ConnectivityBuilder(builder: (context, isConnected, status) {
//                 print(status.toString() + "s");
//                 return Container(
//                       padding: EdgeInsets.all(16),
//                       alignment: Alignment.center,
//                       child: ListView(
//                         shrinkWrap: true,
//                         children: [
//                           isConnected != true
//                               ? Icon(
//                             Icons.signal_wifi_off,
//                             size: 120,
//                             color: Theme.of(context).textTheme.caption?.color,
//                           )
//                               : Image.asset('assets/images/logo_transparent.png',
//                               height: 150),
//                           SizedBox(
//                             height: 32,
//                           ),
//                           Container(
//                             width: 100,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 isConnected != true
//                                     ? Text(
//                                   'You are Offline',
//                                   style: Theme.of(context).textTheme.headline6,
//                                 )
//                                     : Text(
//                                   'Initialising',
//                                   style: Theme.of(context).textTheme.headline6,
//                                 ),
//                                 SizedBox(
//                                   width: 24,
//                                 ),
//                                 isConnected == true
//                                     ? CircularProgressIndicator.adaptive()
//                                     : Container(),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 32,
//                           ),
//                           isConnected != true
//                               ? Text(
//                               'Please connect to the internet to prepare the app for first time use. Once this is done you can go offline.',
//                               style: TextStyle(height: 1.4),
//                               textAlign: TextAlign.center)
//                               : Text(
//                             'Please wait while we load the devotions for you...',
//                             textAlign: TextAlign.center,
//                           )
//                         ],
//                       ));
//               }),),
//
//           )
//       );
//     },
//   );
//
//   if (await Connectivity().checkConnection())
//     await DownloadService.instance.initialize();
//   Future.delayed(Duration(seconds: 8), () {
//     UserService.instance
//         .modifyDownloadedLangMap(UserService.instance.locale, true);
//     Navigator.pop(
//         context);
//   });
// }
