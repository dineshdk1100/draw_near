import 'dart:async';
import 'package:draw_near/provider/login_controller.dart';
import 'package:draw_near/screens/login.dart';
import 'package:draw_near/screens/onboarding.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginController(),
          child: LoginPage(),
        )
      ],

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

        home: SplashScreen(),
      ),
    );
}
  }

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo here
            Image.asset(
              'assets/images/logoresize.png',
              height: 320,
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
            )
          ],
        ),
      ),
    );
  }
}

/**
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
}**/
