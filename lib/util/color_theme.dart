import 'package:flutter/material.dart';

const MaterialColor pastelTheme = MaterialColor(_pastelThemePrimaryValue, <int, Color>{
  50: Color(0xFFFDF3F3),
  100: Color(0xFFFAE1E1),
  200: Color(0xFFF7CDCD),
  300: Color(0xFFF4B8B8),
  400: Color(0xFFF1A9A9),
  500: Color(_pastelThemePrimaryValue),
  600: Color(0xFFED9292),
  700: Color(0xFFEB8888),
  800: Color(0xFFE87E7E),
  900: Color(0xFFE46C6C),
});
 const int _pastelThemePrimaryValue = 0xFFEF9A9A;

 const MaterialColor pastelThemeAccent = MaterialColor(_pastelThemeAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_pastelThemeAccentValue),
  400: Color(0xFFFFF4F4),
  700: Color(0xFFFFDADA),
});
 const int _pastelThemeAccentValue = 0xFFFFFFFF;

 const MaterialColor pastelDarkTheme = MaterialColor(pastelDarkThemePrimaryValue, <int, Color>{
  50: Color(0xFFF7EDED),
  100: Color(0xFFEAD3D3),
  200: Color(0xFFDDB5B6),
  300: Color(0xFFCF9798),
  400: Color(0xFFC48182),
  500: Color(pastelDarkThemePrimaryValue),
  600: Color(0xFFB36364),
  700: Color(0xFFAB5859),
  800: Color(0xFFA34E4F),
  900: Color(0xFF943C3D),
});
 const int pastelDarkThemePrimaryValue = 0xFFBA6B6C;

 const MaterialColor pastelDarkThemeAccent = MaterialColor(pastelDarkThemeAccentValue, <int, Color>{
  100: Color(0xFFFFE5E5),
  200: Color(pastelDarkThemeAccentValue),
  400: Color(0xFFFF7F80),
  700: Color(0xFFFF6567),
});
 const int pastelDarkThemeAccentValue = 0xFFFFB2B2;