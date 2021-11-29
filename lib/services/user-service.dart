import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService {
  static final UserService instance = UserService._internal();
  late Box _baseBox;
  late Locale _userLocale;
  late bool _isOfflineEnabled;
  late double _fontSize;

  factory UserService() {
    return instance;
  }
  UserService._internal(){
    _baseBox = Hive.box('draw_near');

    _isOfflineEnabled = _baseBox.get('offline', defaultValue: true);
    _fontSize = _baseBox.get('fontSize', defaultValue: 16.toDouble());
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
}

