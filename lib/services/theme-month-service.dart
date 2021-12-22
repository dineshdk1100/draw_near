import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/theme_month.dart';
import 'package:draw_near/models/theme_month.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeMonthService {
  var box = Hive.box('draw_near');
  late Map<String, dynamic> themeMonthsMap;


  static final ThemeMonthService instance = ThemeMonthService._internal();
  ThemeMonthService._internal(){
    getThemeMonthsForCurrentLocale();
  }

  getThemeMonthsForCurrentLocale(){
    this.themeMonthsMap = jsonDecode(box.get('themeMonths_${UserService.instance.locale}', defaultValue: '{}'));
  }

  ThemeMonth getThemeMonth(String monthName) {
    //return _themeMonth;
    print(monthName);
    print(themeMonthsMap.keys);
    return ThemeMonth.fromJson(themeMonthsMap[monthName]);
  }

  void saveThemeMonth(String monthName, Map<String, dynamic> data){
    themeMonthsMap[monthName] = data;
  }

  void saveThemeMonths(QuerySnapshot<Map<String, dynamic>> snapshots) {
    snapshots.docs.forEach((doc) {
      print(doc.data());
      ThemeMonthService.instance.saveThemeMonth(doc.id, doc.data());
    });
    box.put('themeMonths_${UserService.instance.locale}', jsonEncode(themeMonthsMap));
  }

}
