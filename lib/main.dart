import 'dart:async';
import 'package:draw_near/provider/login_controller.dart';
import 'package:draw_near/screens/base-home.dart';
import 'package:draw_near/screens/language.dart';
import 'package:draw_near/screens/login.dart';
import 'package:draw_near/services/download-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/theme-manager.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

final newVersion = NewVersion();
void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox('draw_near');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;


    runApp(BetterFeedback(
      theme: FeedbackThemeData(drawColors: [Colors.red, Colors.green, Colors.blue]),
      child: EasyLocalization(
        supportedLocales: [Locale('en', 'IN'), Locale('ta', 'IN')],
        fallbackLocale: Locale('en', 'IN'),
        path: 'assets/locales',
        child: MyApp(),
      ),
    ));

  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserService.instance.locale = context.locale.toString();
    ThemeData darkThemeData = ThemeData(
      textTheme: GoogleFonts.robotoTextTheme().merge(Typography.whiteHelsinki),
      brightness: Brightness.dark,
      primarySwatch: pastelTheme,
      toggleableActiveColor: Color(pastelThemePrimaryValue),
      toggleButtonsTheme: Theme.of(context)
          .toggleButtonsTheme
          .copyWith(borderRadius: BorderRadius.circular(8)),
      cardTheme: Theme.of(context).cardTheme.copyWith(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4),
    );
    return ThemeModeHandler(
        manager: MyManager(),
        builder: (ThemeMode themeMode) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => LoginController(),
                child: LoginPage(),
              )
            ],
            child: MaterialApp(
              themeMode: themeMode,
              title: 'Draw Near',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(
                textTheme: GoogleFonts.robotoTextTheme(),
                primarySwatch: pastelTheme,
                //primaryColor: Colors.blue.shade100,
                brightness: Brightness.light,
                toggleButtonsTheme: Theme.of(context)
                    .toggleButtonsTheme
                    .copyWith(borderRadius: BorderRadius.circular(8)),
                cardTheme: Theme.of(context).cardTheme.copyWith(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4),
              ),
              darkTheme: darkThemeData.copyWith(
                  colorScheme: darkThemeData.colorScheme
                      .copyWith(secondary: Color(pastelThemePrimaryValue))),
              home: SplashScreen(),
            ),
          );
        });
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseCrashlytics.instance.setUserIdentifier(UserService.instance.userDetails.uid);
    Timer(Duration(milliseconds: 1500), () {
      if(UserService.instance.isAppInitialized) {
        DownloadService.instance.initialize();
        if (UserService.instance.isLoggedIn)
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => BaseHome()));
        else
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
      }
      else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Language()));
      }
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
              'assets/images/logo_transparent.png',
              height: 200,
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              //valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade100),
              valueColor: AlwaysStoppedAnimation<Color>(Color(pastelThemePrimaryValue)),
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
