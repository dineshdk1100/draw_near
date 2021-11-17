import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/screens/home.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('draw_near');

  runApp(EasyLocalization(
    startLocale: UserService.instance.userLocale,
    supportedLocales: [Locale('en', 'IN'), Locale('ta', 'IN')],
    fallbackLocale: Locale('en', 'IN'),
    path: 'assets/locales',
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ThemeData darkThemeData = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: pastelDarkTheme,
      toggleableActiveColor: Color(pastelDarkThemePrimaryValue),
    );
    return MaterialApp(
      title: 'Draw Near',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: pastelTheme,
        brightness: Brightness.light,
        cardTheme: Theme.of(context).cardTheme.copyWith(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4),
      ),
      darkTheme: darkThemeData.copyWith(colorScheme: darkThemeData.colorScheme.copyWith(secondary: Color(pastelDarkThemePrimaryValue))),
      home: initializeApp(),
    );
  }

  /// checks for first time usage | logged in user | logged out user and returns the appropriate widget
  Widget initializeApp() {
    Hive.openBox('draw_near_' + UserService.instance.userLocale.toString());
    return BaseHome();
  }
}
