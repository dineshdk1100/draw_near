import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';

class UserService {
  static final UserService instance = UserService._internal();
  late Box _baseBox;
  late String _locale;

  String get locale => _locale;

  set locale(String value) {
    _locale = value;
  }

  late bool _isOfflineEnabled;
  late double _fontSize;
  late double _bodyTextStyleHeight;
  late bool _isLoggedIn;

  factory UserService() {
    return instance;
  }
  UserService._internal() {
    _baseBox = Hive.box('draw_near');

    _bodyTextStyleHeight =
        _baseBox.get('bodyTextStyleHeight', defaultValue: 1.55);
    _isLoggedIn = _baseBox.get('user_details', defaultValue: false);
    _isOfflineEnabled = _baseBox.get('offline', defaultValue: true);
    _fontSize = _baseBox.get('fontSize', defaultValue: 0.toDouble());
  }

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    _baseBox.put('user_details', false);
  }

  bool get isOfflineEnabled => _isOfflineEnabled;

  set isOfflineEnabled(bool value) {
    _isOfflineEnabled = value;
    _baseBox.put('offline', value);
  }

  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    _baseBox.put('fontSize', value);
  }

  double get bodyTextStyleHeight => _bodyTextStyleHeight;

  set bodyTextStyleHeight(double value) {
    _bodyTextStyleHeight = value;
    _baseBox.put('bodyTextStyleHeight', value);
  }
}
