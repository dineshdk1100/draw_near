import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService {
  static final UserService instance = UserService._internal();
  factory UserService() {
    return instance;
  }
  UserService._internal(){
    var baseBox = Hive.box('draw_near');
    List<String> localeList = baseBox.get('locale', defaultValue: 'en_IN').split('_');
    userLocale = Locale(localeList[0], localeList[1]);

    isOfflineEnabled = baseBox.get('offline', defaultValue: true);
  }

  late Locale userLocale;
  late bool isOfflineEnabled;


}

