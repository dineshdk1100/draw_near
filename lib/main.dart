import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/screens/devotion.dart';
import 'package:draw_near/screens/home.dart';
import 'package:draw_near/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:draw_near/provider/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('draw_near');

  runApp(EasyLocalization(
    supportedLocales: [Locale('en', 'IN'), Locale('ta', 'IN')],
    fallbackLocale: Locale('en', 'IN'),
    path: 'assets/locales',
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserService.instance.locale = context.locale.toString();
    ThemeData darkThemeData = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: pastelDarkTheme,
      toggleableActiveColor: Color(pastelDarkThemePrimaryValue),
      toggleButtonsTheme: Theme.of(context).toggleButtonsTheme.copyWith(borderRadius: BorderRadius.circular(8)),
      cardTheme: Theme.of(context).cardTheme.copyWith(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4),
    );
      return ChangeNotifierProvider(

        create: (context) => GoogleSignInProvider(),

        child: MaterialApp(

          title: 'Draw Near',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          theme: ThemeData(
            primarySwatch: pastelTheme,
            brightness: Brightness.light,
            toggleButtonsTheme: Theme.of(context).toggleButtonsTheme.copyWith(borderRadius: BorderRadius.circular(8)),
            cardTheme: Theme
                .of(context)
                .cardTheme
                .copyWith(
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 4),
          ),
          darkTheme: darkThemeData.copyWith(
              colorScheme: darkThemeData.colorScheme
                  .copyWith(secondary: Color(pastelDarkThemePrimaryValue))),
          // routes: {
          //   '/home': (context) => const BaseHome(),
          // },
          home: Initializer(),
        ),
      );
}
  }


/// checks for first time usage | logged in user | logged out user and returns the appropriate widget
class Initializer extends StatefulWidget {
  const Initializer({Key? key}) : super(key: key);

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
