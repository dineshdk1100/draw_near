import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jiffy/jiffy.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                height: mediaQueryData.size.height * 0.17,
                color: Theme.of(context).primaryColor,
              ),
              Positioned(
                  bottom: -70.0,
                  child: CircleAvatar(
                    radius: 100,
                    child: Text(
                      'H',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 80,
          ),
          Text("Harikrishnan", style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.center,),
          SizedBox(
            height: 10,
          ),
          Text("hari@gmail.com", style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center),
          SizedBox(
            height: 8,
          ),
          Text("+91987654321", style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center),
          Divider(height: 24,),
          ListTile(
            isThreeLine: true,
            title: Text("offline_mode".tr()),
            subtitle: Text("offline_mode_desc".tr()),
            trailing: Switch.adaptive(
                value: UserService.instance.isOfflineEnabled,
                onChanged: (newValue) => setState(() {
                      UserService.instance.isOfflineEnabled = newValue;
                    })),
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
