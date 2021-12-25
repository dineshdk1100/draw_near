import 'package:draw_near/screens/onboarding.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:draw_near/util/constants.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class Language extends StatefulWidget {
  @override
  _language createState() => _language();
}

class _language extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // SizedBox(height:60,),

            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset(
            "assets/images/logo_transparent.png",
            height: 150,
          ),
        ),
        // Text(" CHOOSE YOUR APP LANGUAGE ", style: TextStyle(fontSize: 20,color: Colors.blue.shade300),),
        Text(
          " CHOOSE YOUR APP LANGUAGE ",
          style: TextStyle(fontSize: 20, color: Color(pastelThemePrimaryValue)),
        ),

        SizedBox(
          height: 20,
        ),
        ListTile(
          isThreeLine: true,
          title: Text("change_lang".tr() + '  (மொழியை மாற்றவும்)'),
          subtitle: Text("change_lang_desc".tr()),
          trailing: DropdownButton(
            onChanged: onSelectLanguage,
            value: context.locale.toString(),
            items: AVAILABLE_LANGUAGES.keys
                .map((lang) => DropdownMenuItem(
                      enabled: lang == 'en_IN' ? true : false,
                      child: Text(AVAILABLE_LANGUAGES[lang] ?? 'unknown_lang'),
                      value: lang,
                    ))
                .toList(),
          ),
        ),
        Divider(),
        /* ListTile(
            //isThreeLine: true,
              onTap: (){

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select theme'),
                      content: Container(
                        height: 180,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                                leading: Icon(Icons.light_mode),
                                title: Text("Light theme"),
                                onTap: () { Navigator.pop(context); ThemeModeHandler.of(context)?.saveThemeMode(ThemeMode.light);}

                            ),
                            ListTile(
                                leading: Icon(Icons.dark_mode),
                                title: Text("Dark theme"),
                                onTap: ()  { Navigator.pop(context); ThemeModeHandler.of(context)?.saveThemeMode(ThemeMode.dark);}

                            ),
                            ListTile(
                                leading: Icon(Icons.brightness_4),
                                title: Text("System theme"),
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
              //subtitle: Text(UserService.instance.theme.toString().capitalize().tr()),
              trailing: Icon(Icons.arrow_forward_ios)
          ),*/
        SizedBox(
          height: 20,
        ),
        Container(
            margin: EdgeInsets.all(15),
            width: 180,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // primary: Colors.blue.shade100, // background
                primary: Color(pastelThemePrimaryValue), // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                // if(hasValue()) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (c) => Onboarding(),
                ));
                // }
              },
              child: Text(
                'OK',
                style: TextStyle(
                    fontFamily: 'San Francisco',
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ))
      ],
    )));
  }

  onSelectLanguage(value) {
    if (value == null) return;
    var localeTemp = value.toString().split('_');
    context.setLocale(Locale(localeTemp[0], localeTemp[1]));
    UserService.instance.locale = value;
  }
}
