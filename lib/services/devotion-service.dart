import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/util/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DevotionService {
  var box = Hive.box('draw_near');
  late List devotionsJson;

  static final DevotionService instance = DevotionService._internal();
  factory DevotionService() {
    return instance;
  }
  DevotionService._internal();

  List<Devotion> getDevotionsForMonth(String month) {
    this.devotionsJson = box.get(month, defaultValue: List.empty());
    return devotionsJson.map((dev) => Devotion.fromJson(dev)).toList();
  }

  Devotion getDevotionsForDate(DateTime date) {
    this.devotionsJson = box.get(MONTHS_IN_YEAR[date.month], defaultValue: List.empty());
    return Devotion.fromJson(this.devotionsJson[date.day - 1]);

  }

  getDevotionsForWeek(DateTime startDate, DateTime endDate) {}
}
