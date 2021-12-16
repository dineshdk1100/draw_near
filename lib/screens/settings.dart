import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/provider/login_controller.dart';
import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/services/devotion-service.dart';
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
                height: mediaQueryData.size.height * 0.13,
                color: Theme.of(context).primaryColor,
              ),
              Positioned(
                  bottom: -70.0,
                  child: CircleAvatar(
                    radius: 70,onBackgroundImageError: (obj, _)=> Icon(Icons.person, size: 100, color: Colors.white,),
                    backgroundImage: CachedNetworkImageProvider(UserService.instance.userDetails.photoURL ?? ''),
                  )),
            ],
          ),
          SizedBox(
            height: 80,
          ),
          Text(UserService.instance.userDetails.displayName, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,),
          SizedBox(
            height: 10,
          ),
          Text(UserService.instance.userDetails.email ?? '', style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center),
          SizedBox(
            height: 8,
          ),
          Text(UserService.instance.userDetails.phoneNumber ?? '', style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center),
          Divider(height: 24,),
          ListTile(
            //isThreeLine: true,
            title: Text("offline_mode".tr()),
            subtitle: Text(DevotionService.instance.devotionsMap.length.toString() + " " + "offline_mode_desc".tr()),
            // trailing: Switch.adaptive(
            //     value: UserService.instance.isOfflineEnabled,
            //     onChanged: (newValue) => setState(() {
            //           UserService.instance.isOfflineEnabled = newValue;
            //         })),
          ),
          Divider(),
          ListTile(
            //isThreeLine: true,
            onTap: (){

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
                          onTap: () { Navigator.pop(context); ThemeModeHandler.of(context)?.saveThemeMode(ThemeMode.light);}

                        ),
                        ListTile(
                          leading: Icon(Icons.dark_mode),
                          title: Text("dark".tr()),
                          onTap: ()  { Navigator.pop(context); ThemeModeHandler.of(context)?.saveThemeMode(ThemeMode.dark);}

                        ),
                        ListTile(
                          leading: Icon(Icons.brightness_4),
                          title: Text("system".tr()),
                          onTap: ()  { Navigator.pop(context);  ThemeModeHandler.of(context)?.saveThemeMode(ThemeMode.system);}

                        )
                      ],
                      ),
                    ),
                  );
                },
              );
            },
            title: Text("theme".tr()),
            subtitle: Text(UserService.instance.theme.toString().tr()),
            trailing: Icon(Icons.arrow_forward_ios)
          ),
          Divider(),

          ListTile(
            isThreeLine: true,
            title: Text("change_lang".tr()),
            subtitle: Text("change_lang_desc".tr()),
            trailing: DropdownButton(
              onChanged: onSelectLanguage,
              value: context.locale.toString(),
              items: AVAILABLE_LANGUAGES.keys
                  .map((lang) => DropdownMenuItem(
                        child: Text(
                            AVAILABLE_LANGUAGES[lang] ?? 'unknown_lang'),
                        value: lang,
                      ))
                  .toList(),
            ),
          ),
          Divider(),
          ListTile(
            onTap: (){
              if(!UserService.instance.isLoggedIn){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));

              }
              else{
                Provider.of<LoginController>(context, listen: false).logout();
                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BaseHome()), (route) => false);
              }
            },
            title: UserService.instance.isLoggedIn ? Text('logout'.tr()) : Text("login".tr()),
            trailing: Icon(Icons.logout),
          )
        ],
      ),
    );
  }

  onSelectLanguage(value){
    if (value == null) return;
    var localeTemp = value.toString().split('_');
    context.setLocale(Locale(localeTemp[0], localeTemp[1]));
    UserService.instance.locale = value;
  }

}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
