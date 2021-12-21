import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/provider/login_controller.dart';
import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/screens/edit_profile_page.dart';
import 'package:draw_near/screens/language.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/download-service.dart';
import 'package:draw_near/services/notification-service.dart';
import 'package:draw_near/services/profile_widget.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

import 'login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    // TODO: implement initState
    print(UserService.instance.isLoggedIn.toString());
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          TextButton.icon(
            onPressed: () {
              if (!UserService.instance.isLoggedIn) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else {

                DownloadService.instance.removeLocalLastModified();
                Provider.of<LoginController>(context, listen: false).logout();
                UserService.instance.isLoggedIn = false;
                print('is logged in');
                print(UserService.instance.isLoggedIn);
                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (route) => false);
              }
            },
            icon: UserService.instance.isLoggedIn
                ? Text('logout'.tr().toUpperCase(),style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),)
                : Text("login".tr().toUpperCase(), style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color)),
            label: Icon(Icons.logout, color: Theme.of(context).textTheme.bodyText1?.color,),
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
                height: mediaQueryData.size.height * 0.12,
                color: Theme.of(context).primaryColor,
              ),


              Positioned(
                bottom: -50.0,
                child:
                CachedNetworkImage(
                  height: 100,
                  fit: BoxFit.cover,
                  imageUrl: UserService.instance.userDetails.photoURL ?? '',
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
          Text(UserService.instance.userDetails.email ?? '',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center),
          SizedBox(
            height: 8,
          ),
          Text(UserService.instance.userDetails.phoneNumber ?? '',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center),
          Divider(
            height: 24,
          ),
          ListTile(
            title: Text("Edit profile"),
            onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Language()),
                );

            },
          ),
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
                enabled: lang=='en_IN' ? true : false,
                      ))
                  .toList(),
            ),
          ),
          Divider(),
          ListTile(
            title: Text("daily_reminder".tr()),
            trailing: Switch.adaptive(
                value: UserService.instance.isReminderOn,
                onChanged: (newValue) => setState(() {
                      UserService.instance.isReminderOn = newValue;
                      if(newValue)
                        NotificationService.instance.scheduleNotification();
                      else
                        NotificationService.instance.cancelNotification();
                    })),
          ),
          ListTile(
            enabled: UserService.instance.isReminderOn,
            onTap: onOpenTimePicker,
            // leading: Icon(
            //   Icons.edit_notifications,
            // ),
            title: Text('select_time'.tr()),
            trailing: Text(UserService.instance.reminderTime.hour.toString().padLeft(2, '0') +
                ' : ' +
                UserService.instance.reminderTime.minute.toString().padLeft(2, '0')),
          ),
          ListTile(
            title: Text('Reminder not working ?'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NotificationService.instance.showNotification();
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Disable battery optimization'),
                        content: Text(
                            'Some smartphones use battery optimization to close apps running in the background. This can cause reminders to get delayed or not work at all. We recommend you to disable battery optimization to ensure timely reminders.', textAlign: TextAlign.justify,),
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
    );
  }

  onSelectLanguage(value) {
    if (value == null) return;
    var localeTemp = value.toString().split('_');
    context.setLocale(Locale(localeTemp[0], localeTemp[1]));
    UserService.instance.locale = value;
  }

  void onOpenTimePicker() async {
    var selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedTime != null) {
      setState(() {
        UserService.instance.reminderTime = selectedTime;
      }
      );
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
