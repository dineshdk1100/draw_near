import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draw_near/exceptions/devotion-not-found.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/screens/devotion.dart';
import 'package:draw_near/services/carousel-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:octo_image/octo_image.dart';

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
      devotion = _devotionService.getDevotionsForDate(DateTime.now());
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
        title: Text("Draw Near"),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,

        actions: [
          PopupMenuButton(itemBuilder: (context) =>[
    PopupMenuItem(child: Text("About us"),),
    PopupMenuItem(child: Text("Feedback")),
    PopupMenuItem(child: Text("Share this app")),
    PopupMenuItem(child: Text("Privacy Policy"))
    ],
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
          Image.asset('assets/images/logo_transparent.png', height: 90,),
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
          // SizedBox(
          //   height: 16,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.accessibility_new_outlined),
                title: Text("Gratitude"),
                subtitle: Text('theme_month'.tr()),
                onTap: navigateToThemePage,
              ),
            ),
          )
        ],
      ),
    );
  }


  navigateToDevotionPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DevotionPage(DateTime.now())));
  }

  navigateToThemePage(){

  }
}
