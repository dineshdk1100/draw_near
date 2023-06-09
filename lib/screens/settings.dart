import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw_near/provider/login_controller.dart';
import 'package:draw_near/screens/edit_profile_page.dart';
import 'package:draw_near/screens/initializer.dart';
import 'package:draw_near/services/author-service.dart';
import 'package:draw_near/services/carousel-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/download-service.dart';
import 'package:draw_near/services/notification-service.dart';
import 'package:draw_near/services/song-service.dart';
import 'package:draw_near/services/theme-month-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/services/verse-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:draw_near/util/offline-alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with ScreenLoader {
  @override
  void initState() {
    // TODO: implement initState
    print(UserService.instance.isLoggedIn.toString());
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    return loadableWidget(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            TextButton.icon(
              onPressed: () async {
                if (await isUserOffline(context)) return;
                if (!UserService.instance.isLoggedIn) {
                  UserService.instance.isGuest = false;
                  Phoenix.rebirth(context);
                } else {
                  DownloadService.instance.removeLocalLastModified();
                  //DownloadService.instance.initialize();
                  await performFuture(
                      Provider.of<LoginController>(context, listen: false)
                          .logout);
                  Phoenix.rebirth(context);
                  //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (route) => false);
                }
              },
              icon: UserService.instance.isLoggedIn
                  ? Text(
                      'logout'.tr().toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1?.color),
                    )
                  : Text("login".tr().toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1?.color)),
              label: Icon(
                Icons.logout,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
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
                  width: mediaQueryData.size.width,
                  height: mediaQueryData.size.height * 0.10,
                  color: Theme.of(context).primaryColor,
                ),
                Positioned(
                  bottom: -50.0,
                  child: UserService.instance.userDetails.photoURL == ''
                      ? CircleAvatar(
                          radius: 80,
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        )
                      : CachedNetworkImage(
                          height: 100,
                          fit: BoxFit.cover,
                          imageUrl:
                              UserService.instance.userDetails.photoURL ?? '',
                          errorWidget: (context, s, _) => CircleAvatar(
                            radius: 80,
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          imageBuilder: (context, provider) => CircleAvatar(
                            radius: 60,
                            backgroundImage: provider,
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              UserService.instance.userDetails.displayName,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            UserService.instance.userDetails.email != null &&
                    UserService.instance.userDetails.email!.trim().isNotEmpty
                ? Text(UserService.instance.userDetails.email ?? '',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center)
                : Container(),
            SizedBox(
              height: 8,
            ),
            UserService.instance.userDetails.phoneNumber != null &&
                    UserService.instance.userDetails.phoneNumber!
                        .trim()
                        .isNotEmpty
                ? Text(UserService.instance.userDetails.phoneNumber ?? '',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center)
                : Container(),
            ListTile(
              //trailing: Icon(Icons.navigate_next),
              enabled: UserService.instance.isLoggedIn,
              title: Text("edit_profile".tr()),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    )
                    .then((value) => setState(() {}));
              },
            ),
            Divider(),
            ListTile(
              //isThreeLine: true,
              title: Text("offline_mode".tr()),
              subtitle: Text(
                  DevotionService.instance.devotionsMap.length.toString() +
                      " " +
                      "offline_mode_desc".tr()),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Refresh'),
                          content: Text(
                            'Devotions in Tamil will be added later. If you are unable to view any devotions in English please connect to the internet, logout and login again to perform a refresh.',
                            textAlign: TextAlign.justify,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OKAY'))
                          ],
                        ));
              },
              trailing: Icon(Icons.help_outline),
            ),
            Divider(),
            ListTile(
              //isThreeLine: true,
              title: Text("change_lang".tr()),
              subtitle: Text("change_lang_desc".tr()),
              trailing: DropdownButton(
                onChanged: onSelectLanguage,
                value: context.locale.toString(),
                items: AVAILABLE_LANGUAGES.keys
                    .map((lang) => DropdownMenuItem(
                          child:
                              Text(AVAILABLE_LANGUAGES[lang] ?? 'unknown_lang'),
                          value: lang,
                          enabled: lang != UserService.instance.locale
                              ? true
                              : false,
                        ))
                    .toList(),
              ),
            ),
            Divider(),
            ListTile(
              minVerticalPadding: 0,
              title: Text('daily_reminder'.tr()),
              trailing: Switch.adaptive(
                  value: UserService.instance.isReminderOn,
                  onChanged: (newValue) => setState(() {
                        UserService.instance.isReminderOn = newValue;
                        if (newValue)
                          NotificationService.instance.scheduleNotification();
                        else
                          NotificationService.instance.cancelNotification();
                      })),
            ),
            ListTile(
              minVerticalPadding: 0,
              enabled: UserService.instance.isReminderOn,
              onTap: onOpenTimePicker,
              // leading: Icon(
              //   Icons.edit_notifications,
              // ),
              title: Text('select_time'.tr()),
              trailing: Text(UserService.instance.reminderTime.hour
                      .toString()
                      .padLeft(2, '0') +
                  ' : ' +
                  UserService.instance.reminderTime.minute
                      .toString()
                      .padLeft(2, '0')),
            ),
            ListTile(
              minVerticalPadding: 0,
              title: Text('reminder_not_working'.tr()),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                //NotificationService.instance.showNotification();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Disable battery optimization'),
                          content: Text(
                            'Some smartphones use battery optimization to close apps running in the background. This can cause reminders to get delayed or not work at all. We recommend you to disable battery optimization to ensure timely reminders.',
                            textAlign: TextAlign.justify,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OKAY'))
                          ],
                        ));
              },
            ),
            Divider(),
            ListTile(
                //isThreeLine: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('select_theme'.tr()),
                        content: Container(
                          height: 180,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                  leading: Icon(Icons.light_mode),
                                  title: Text("light".tr()),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ThemeModeHandler.of(context)
                                        ?.saveThemeMode(ThemeMode.light);
                                  }),
                              ListTile(
                                  leading: Icon(Icons.dark_mode),
                                  title: Text("dark".tr()),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ThemeModeHandler.of(context)
                                        ?.saveThemeMode(ThemeMode.dark);
                                  }),
                              ListTile(
                                  leading: Icon(Icons.brightness_4),
                                  title: Text("system".tr()),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ThemeModeHandler.of(context)
                                        ?.saveThemeMode(ThemeMode.system);
                                  })
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                title: Text("theme".tr()),
                subtitle: Text(UserService.instance.theme.toString().tr()),
                trailing: Icon(Icons.navigate_next)),
          ],
        ),
      ),
    );
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
      DownloadService.instance.initialize(loadInBackground: true);
    }
  }

  void onOpenTimePicker() async {
    var selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedTime != null) {
      setState(() {
        UserService.instance.reminderTime = selectedTime;
      });
      await NotificationService.instance.cancelNotification();
      NotificationService.instance.scheduleNotification();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
