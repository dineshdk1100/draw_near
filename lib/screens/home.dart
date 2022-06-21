import 'dart:convert';
import 'dart:io' show Directory, File, Platform;

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draw_near/exceptions/devotion-not-found.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/models/theme_month.dart';
import 'package:draw_near/screens/devotion.dart';
import 'package:draw_near/screens/initializer.dart';
import 'package:draw_near/screens/theme_month_details.dart';
import 'package:draw_near/services/carousel-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/theme-month-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:draw_near/util/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/author-service.dart';
import '../services/download-service.dart';
import '../services/song-service.dart';
import '../services/verse-service.dart';

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
  ThemeMonth? themeMonth;
  List? images;
  //final newVersion = NewVersion();
  @override
  void initState() {
    //newVersion.showAlertIfNecessary(context: context);

    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_transparent.png',
          height: 55,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Go to website"),
                value: 0,
              ),
              PopupMenuItem(child: Text("Report an issue"), value: 1),
              PopupMenuItem(child: Text("Feedback"), value: 2),
              PopupMenuItem(child: Text("Share this app"), value: 3),
              // PopupMenuItem(child: Text("Privacy Policy"), value: 4)
            ],
            onSelected: onPopUpMenuItemSelected,
          )
        ],
      ),
      body:
          //UpgradeAlert(canDismissDialog: false,showIgnore: false,showLater: true,
          ListView(
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
                bottom: -120.0,
                child: Container(
                  width: width,
                  height: height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).scaffoldBackgroundColor
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: CarouselSlider.builder(
                    itemCount: images?.length ?? 0,
                    options: CarouselOptions(
                        //height: height * 0.35,
                        viewportFraction: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 0.4
                            : 0.8,
                        autoPlay: true,
                        enlargeCenterPage: true),
                    itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) =>
                        Card(
                      clipBehavior: Clip.antiAlias,
                      child: OctoImage.fromSet(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(images?[itemIndex]
                                ['url'] ??
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
            height: 100,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () => onSelectLanguage('ta_IN'),
                child: Text(
                  "தமிழ்",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                ),
                style: context.locale.toString() == 'ta_IN'
                    ? OutlinedButton.styleFrom(
                        backgroundColor: Color(pastelThemePrimaryValue))
                    : OutlinedButton.styleFrom(),
              ),
              OutlinedButton(
                onPressed: () => onSelectLanguage('en_IN'),
                child: Text(
                  "English",
                  style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                ),
                style: context.locale.toString() == 'en_IN'
                    ? OutlinedButton.styleFrom(
                        backgroundColor: Color(pastelThemePrimaryValue))
                    : OutlinedButton.styleFrom(),
              ),
              OutlinedButton(
                onPressed: () => Fluttertoast.showToast(msg: "Coming soon!"),
                child: Text(
                  "हिन्दी",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                ),
                style: context.locale.toString() == 'hi_IN'
                    ? OutlinedButton.styleFrom(
                        backgroundColor: Color(pastelThemePrimaryValue))
                    : OutlinedButton.styleFrom(),
              ),
            ],
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
                    title: Text(devotion?.title ?? "devotion_unavailable".tr(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline4?.color)),
                    subtitle: Text('devotion_day'.tr(),
                        style: TextStyle(fontSize: 16)),
                  ),
                  Divider(),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                        devotion?.body ?? "devotion_unavailable_desc".tr(),
                        textAlign: TextAlign.justify,
                        maxLines: 6,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  TextButton(
                      onPressed:
                          (devotion != null) ? navigateToDevotionPage : null,
                      child: Text('read_more'.tr().toUpperCase()))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Badge(
                animationType: BadgeAnimationType.scale,
                shape: BadgeShape.circle,
                badgeColor: Color(pastelThemePrimaryValue),
                //elevation: 0,
                badgeContent: Icon(
                  Icons.notifications,
                  size: 16,
                  color: Colors.white,
                ),
                position: BadgePosition.topEnd(),
                borderRadius: BorderRadius.circular(5),
                showBadge: DateTime.now().day == 1,
                child: ListTile(
                  trailing: Icon(Icons.navigate_next),
                  leading: Icon(Icons.accessibility_new_outlined),
                  /* title: Text("Gratitude"),
                    subtitle: Text('theme_month'.tr(namedArgs: {
                      'month': DateFormat("MMMM", context.locale.languageCode)
                          .format(DateTime.now())
                    })),*/

                  title: DateTime.now().year == 2021
                      ? Text("Gratitude")
                      : Text(themeMonth?.title ?? "Unavailable"),
                  subtitle: Text('theme_month'.tr(namedArgs: {
                    'month': DateFormat("MMMM", context.locale.languageCode)
                        .format(DateTime.now())
                  })),
                  onTap: navigateToThemePage,
                ),
              ),
            ),
          ),
        ],
      ),
      //),
    );
  }

  navigateToDevotionPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DevotionPage(DateTime.now())));
  }

  navigateToThemePage() {
    if (DateTime.now().year == 2021)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ThemeMonthDetails('january')));
    else
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ThemeMonthDetails(MONTHS_IN_YEAR[DateTime.now().month - 1])));
  }

  void onPopUpMenuItemSelected(int value) {
    switch (value) {
      case 0:
        _launchURL('https://www.drawnear.life');
        break;
      case 1:
        sendReport();
        break;
      case 2:
        sendFeedback();
        break;
      case 3:
        if (Platform.isAndroid)
          Share.share(
              'https://play.google.com/store/apps/details?id=com.techcatalyst.draw_near');
        else
          Share.share('Download Draw near from App store');
        break;
      case 4:
        break;
    }
  }

  void sendReport() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    List<File> files = [];
    files.add(await File(tempPath + '/log_data.json').create()
      ..writeAsString(jsonEncode(UserService.instance.getAllUserData())));

    BetterFeedback.of(context).show((UserFeedback feedback) async {
      print('feed');
      files.add(await File(tempPath + '/screenshot.png').create()
        ..writeAsBytes(feedback.screenshot));

      final Email email = Email(
        body: feedback.text,
        subject: 'Draw Near - Report an issue',
        recipients: ['drawnear2022@gmail.com'],
        cc: ['techcatalyst.solutions@gmail.com', 'drawnear.dev@gmail.com'],
        attachmentPaths: files.map((file) => file.path).toList(),
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(email);
      } on PlatformException catch (e) {
        Fluttertoast.showToast(msg: e.message ?? "Something went wrong!");
        FirebaseCrashlytics.instance.recordError(e, null);
      }
    });
  }

  onSelectLanguage(value) async {
    if (value == null || value == 'hi_IN') return;
    var localeTemp = value.toString().split('_');
    await context.setLocale(Locale(localeTemp[0], localeTemp[1]));
    UserService.instance.locale = value;
    print(context.locale);
    print(UserService.instance.downloadedLangMap);
    if (!UserService.instance.isCurrentLangDownloaded())
      pushNewScreen(context, screen: Initializer(false), withNavBar: false);
    else {
      DevotionService.instance.getDevotionsForCurrentLocale();
      SongService.instance.getSongsForCurrentLocale();
      VerseService.instance.getVersesForCurrentLocale();
      ThemeMonthService.instance.getThemeMonthsForCurrentLocale();
      AuthorService.instance.getAuthorsForCurrentLocale();
      CarouselImageService.instance.getCarouselImagesForCurrentLocale();
      _initialize();
      DownloadService.instance.initialize(loadInBackground: true);
    }
  }

  void sendFeedback() async {
    final Email email = Email(
      body: 'Enter you feedback here...',
      subject: 'Draw Near - User Feedback',
      recipients: ['drawnear.dev@gmail.com'],
      cc: ['techcatalyst.solutions@gmail.com'],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Something went wrong!");
      FirebaseCrashlytics.instance.recordError(e, null);
    }
  }

  void _launchURL(_url) async {
    if (!await launch(_url))
      Fluttertoast.showToast(msg: 'Something went wrong!');
  }

  void _initialize() {
    {
      try {
        images = CarouselImageService.instance.getCarouselImages();
        print(images);
        themeMonth = ThemeMonthService.instance
            .getThemeMonth(MONTHS_IN_YEAR[DateTime.now().month - 1]);
        devotion = _devotionService.getDevotionForDate(DateTime.now());
      } on DevotionNotFoundException catch (e) {
        //Fluttertoast.showToast(msg: e.message);
      }
    }
  }
}
