import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/user.dart';
import 'package:draw_near/services/author-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/download-service.dart';
import 'package:draw_near/services/song-service.dart';
import 'package:draw_near/services/verse-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';

class UserService {
  static final UserService instance = UserService._internal();
  late Box _baseBox;
  late String _locale;
  late UserDetails _userDetails;
  late bool _isAppInitialized;
  late double _fontSize;
  late double _bodyTextStyleHeight;
  late bool _isLoggedIn;
  late String _theme;
  late TimeOfDay _reminderTime;
  late bool _isReminderOn;
  Map<String, dynamic> data = Map();

  UserService._internal() {
    _baseBox = Hive.box('draw_near');

    data["uid"] = "";
    data["displayName"] = "Guest";
    data["email"] = "";
    data["phoneNumber"] = "";

    _bodyTextStyleHeight =
        _baseBox.get('bodyTextStyleHeight', defaultValue: 1.55);
    _isLoggedIn = _baseBox.get('loggedIn', defaultValue: false);
    _isAppInitialized = _baseBox.get('app_initialized', defaultValue: false);
    _fontSize = _baseBox.get('fontSize', defaultValue: 0.toDouble());
    _theme = _baseBox.get('theme', defaultValue: "system");
    _userDetails = UserDetails.fromJson(jsonDecode(
        _baseBox.get('userDetails', defaultValue: jsonEncode(data))));
    String reminderTimeString =
    _baseBox.get('reminder_time', defaultValue: '10:0');
    _reminderTime = TimeOfDay(
        hour: int.parse(reminderTimeString.split(':')[0]),
        minute: int.parse(reminderTimeString.split(':')[1]));
    _isReminderOn = _baseBox.get('reminder', defaultValue: false);
  }

  bool get isReminderOn => _isReminderOn;

  set isReminderOn(bool value) {
    _isReminderOn = value;
    _baseBox.put('reminder', value);
  }

  TimeOfDay get reminderTime => _reminderTime;

  set reminderTime(TimeOfDay value) {
    _reminderTime = value;
    int hour = value.hour;
    int minute = value.minute;
    _baseBox.put('reminder_time', hour.toString() + ':' + minute.toString());
    FirebaseCrashlytics.instance.setCustomKey('reminder_time', hour.toString() + ':' + minute.toString());
  }

  UserDetails get userDetails => _userDetails;

  set userDetails(UserDetails value) {
    _userDetails = value;
    _baseBox.put('userDetails', jsonEncode(value.toJson()));
    FirebaseCrashlytics.instance.setCustomKey('userDetails',  jsonEncode(value.toJson()));

  }

  String get locale => _locale;

  set locale(String value) {
    _locale = value;
    DevotionService.instance.getDevotionsForCurrentLocale();
    SongService.instance.getSongsForCurrentLocale();
    VerseService.instance.getVersesForCurrentLocale();
    AuthorService.instance.getAuthorsForCurrentLocale();
    FirebaseCrashlytics.instance.setCustomKey('locale',  value);

  }

  String get theme => _theme;

  set theme(String value) {
    _theme = value;
    _baseBox.put('theme', _theme);
    FirebaseCrashlytics.instance.setCustomKey('theme',  value);

  }

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    _baseBox.put('loggedIn', value);
    FirebaseCrashlytics.instance.setCustomKey('loggedIn',  value);

  }

  bool get isAppInitialized => _isAppInitialized;

  set isAppInitialized(bool value) {
    _isAppInitialized = value;
    _baseBox.put('app_initialized', value);
    FirebaseCrashlytics.instance.setCustomKey('app_initialized',  value);

  }

  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    _baseBox.put('fontSize', value);
    FirebaseCrashlytics.instance.setCustomKey('fontSize',  value);

  }

  double get bodyTextStyleHeight => _bodyTextStyleHeight;

  set bodyTextStyleHeight(double value) {
    _bodyTextStyleHeight = value;
    _baseBox.put('bodyTextStyleHeight', value);
    FirebaseCrashlytics.instance.setCustomKey('bodyTextStyleHeight',  value);

  }

  removeUserDetails() {
    _baseBox.delete('userDetails');
  }

  Map<dynamic, dynamic> getAllUserData() {
    Map<dynamic, dynamic> map = _baseBox.toMap();
    map.update(UserService.instance.locale, (value) => DevotionService.instance.devotionsMap.length);
    map.update('authors_${UserService.instance.locale}', (value) => jsonDecode(value).length);
    map.update('songs_${UserService.instance.locale}', (value) => jsonDecode(value).length);
    map.update('verses_${UserService.instance.locale}', (value) => jsonDecode(value).length);

    return map;
  }


}
