import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draw_near/exceptions/devotion-not-found.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/screens/devotion.dart';
import 'package:draw_near/services/carousel-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:octo_image/octo_image.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show File, Platform;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> carouselImageUrls = [
    'https://images.pexels.com/photos/1005417/pexels-photo-1005417.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/589802/pexels-photo-589802.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
  ];
  DevotionService _devotionService = DevotionService.instance;
  Devotion? devotion;
  _HomePageState() {
    getCarouselImages().then((urls) => {});

    try {
      devotion = _devotionService.getDevotionForDate(DateTime.now());
    }
    on DevotionNotFoundException catch(e) {
      //Fluttertoast.showToast(msg: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
        Image.asset('assets/images/logo_transparent.png', height: 55,),

        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,

        actions: [
          PopupMenuButton(itemBuilder: (context) =>[
    PopupMenuItem(child: Text("About us"), value: 0,),
    PopupMenuItem(child: Text("Feedback"), value: 1),
    PopupMenuItem(child: Text("Share this app"), value: 2),
    PopupMenuItem(child: Text("Privacy Policy"), value: 3)
    ],
            onSelected: onPopUpMenuItemSelected,
    )
        ],
      ),

      body: ListView(

        shrinkWrap: true,

        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: width,
                height: height * 0.19,
                color: Theme.of(context).primaryColor,
              ),
              Positioned(
                bottom: -70.0,
                child: Container(
                  width: width,
                  height: 200,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10),gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).scaffoldBackgroundColor], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: CarouselSlider.builder(
                    itemCount: carouselImageUrls.length,
                    options: CarouselOptions(

                        autoPlay: true,
                        enlargeCenterPage: true),
                    itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) =>
                        Card(
                      clipBehavior: Clip.antiAlias,
                      child: OctoImage.fromSet(
                        width: width,
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            carouselImageUrls[itemIndex]),
                        octoSet: OctoSet.circularIndicatorAndIcon(
                            showProgress: true),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 64,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Badge(
                animationType: BadgeAnimationType.scale,
                shape: BadgeShape.circle,
                badgeColor: Color(pastelThemePrimaryValue),
                //elevation: 0,
                badgeContent: Icon(Icons.notifications, size: 16, color: Colors.white,),
                position: BadgePosition.topEnd(),
                borderRadius: BorderRadius.circular(5),
                showBadge: DateTime.now().day == 1,
                child: ListTile(
                  trailing: Icon(Icons.navigate_next),
                  leading: Icon(Icons.accessibility_new_outlined),
                  title: Text("Gratitude"),
                  subtitle: Text('theme_month'.tr(namedArgs: {'month': DateFormat( "MMMM",context.locale.languageCode).format(DateTime.now())})),
                  onTap: navigateToThemePage,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.local_library_outlined),
                    title: Text(devotion?.title ?? "devotion_unavailable".tr()),
                    subtitle: Text('devotion_day'.tr()),
                  ),
                  Divider(),
                  Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(devotion?.body ?? "devotion_unavailable_desc".tr(),
                        textAlign: TextAlign.justify,
                        maxLines: 6,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  TextButton(
                      onPressed: (devotion!=null) ? navigateToDevotionPage : null,
                      child: Text('read_more'.tr().toUpperCase()))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  navigateToDevotionPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DevotionPage(DateTime.now())));
  }

  navigateToThemePage(){

  }

  void onPopUpMenuItemSelected(int value) {
    switch(value){
      case 0: break;
      case 1: sendFeedback();
        break;
      case 2:
        if(Platform.isAndroid)
        Share.share('https://play.google.com/store/apps/details?id=com.techcatalyst.draw_near');
        else
          Share.share('Hi');
        break;
      case 3: break;
    }
  }

  void sendFeedback() async{
    File feedbackJson = new File('feedback.json');
    await feedbackJson.writeAsString(jsonEncode(UserService.instance.getAllUserData()));
    Share.shareFiles([feedbackJson.path], subject: "Draw Near Feedback");
    
  }
  }
