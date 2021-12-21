import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/exceptions/devotion-not-found.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';

class DevotionService {
  var box = Hive.box('draw_near');
  late Map<String, dynamic> devotionsMap;

  Devotion _devotion = Devotion(
      "rec",
      DateTime.now(),
      'Power of Compassion',
      ['03'],
      ['rec'],
      'Genesis 1.2',
      ['Truth for Today: Whenever our Lord Jesus Christ was moved with compassion, He did something miraculous! The scene of the widow weeping for the loss of her son moved the Lord with compassion which compelled Him into action and therefore He raised the dead man alive and presented him to his mother. Fear came upon all who witnessed this great miracle of a dead man coming back to life. The true definition of compassion involves a tangible expression of love for those who are suffering. It gives us the ability to understand someone’s struggle and it creates a desire to take action to alleviate their suffering. It is the most powerful force in the world; it benefits both those who receive it and those who share it. Christ when He walked on this earth was filled with compassion for the people, and He wants us also to feel the same divine power. Real life Events: Ida Scudder the woman who grew up in India and couldn’t wait to leave, one night witnessed the death of three women in labor as their husbands refused the help of her father who was a doctor due to the social taboo that existed at that time. Seeing the plight of the women folks of our country, Ida was moved with compassion and so pursued medical studies abroad. She came back to India and served the Lord by founding a teaching hospital, in which women were admitted and trained in medical studies. She brought a huge change in the lives of so many women. Adopt and Apply: Developing a heart for compassion begins in families. When parents lead a compassionate life, children will naturally witness the powerful changes that this attribute brings in their lives and will assume its importance for their lives. Let the power of compassion flow from our families to the society thereby bringing glory to His kingdom.'],
      ['rec'],
      'Truth for Today: Whenever our Lord Jesus Christ was moved with compassion, He did something miraculous! The scene of the widow weeping for the loss of her son moved the Lord with compassion which compelled Him into action and therefore He raised the dead man alive and presented him to his mother. Fear came upon all who witnessed this great miracle of a dead man coming back to life. The true definition of compassion involves a tangible expression of love for those who are suffering. It gives us the ability to understand someone’s struggle and it creates a desire to take action to alleviate their suffering. It is the most powerful force in the world; it benefits both those who receive it and those who share it. Christ when He walked on this earth was filled with compassion for the people, and He wants us also to feel the same divine power. Real life Events: Ida Scudder the woman who grew up in India and couldn’t wait to leave, one night witnessed the death of three women in labor as their husbands refused the help of her father who was a doctor due to the social taboo that existed at that time. Seeing the plight of the women folks of our country, Ida was moved with compassion and so pursued medical studies abroad. She came back to India and served the Lord by founding a teaching hospital, in which women were admitted and trained in medical studies. She brought a huge change in the lives of so many women. Adopt and Apply: Developing a heart for compassion begins in families. When parents lead a compassionate life, children will naturally witness the powerful changes that this attribute brings in their lives and will assume its importance for their lives. Let the power of compassion flow from our families to the society thereby bringing glory to His kingdom.',
      'Truth for Today: Whenever our Lord Jesus Christ was moved with compassion, He did something miraculous! The scene of the widow weeping for the loss of her son moved the Lord with compassion which compelled Him into action and therefore He raised the dead man alive and presented him to his mother. Fear came upon all who witnessed this great miracle of a dead man coming back to life. The true definition of compassion involves a tangible expression of love for those who are suffering. It gives us the ability to understand someone’s struggle and it creates a desire to take action to alleviate their suffering. It is the most powerful force in the world; it benefits both those who receive it and those who share it. Christ when He walked on this earth was filled with compassion for the people, and He wants us also to feel the same divine power. Real life Events: Ida Scudder the woman who grew up in India and couldn’t wait to leave, one night witnessed the death of three women in labor as their husbands refused the help of her father who was a doctor due to the social taboo that existed at that time. Seeing the plight of the women folks of our country, Ida was moved with compassion and so pursued medical studies abroad. She came back to India and served the Lord by founding a teaching hospital, in which women were admitted and trained in medical studies. She brought a huge change in the lives of so many women. Adopt and Apply: Developing a heart for compassion begins in families. When parents lead a compassionate life, children will naturally witness the powerful changes that this attribute brings in their lives and will assume its importance for their lives. Let the power of compassion flow from our families to the society thereby bringing glory to His kingdom.',
      'Truth for Today: Whenever our Lord Jesus Christ was moved with compassion',
      'Truth for Today: Whenever our Lord Jesus Christ was moved with compassion',
      'Ruby Raja',
      ['Ruby Raja'],
      ['rec'],
      12345678);

  static final DevotionService instance = DevotionService._internal();

  DevotionService._internal(){
    getDevotionsForCurrentLocale();
    print(devotionsMap.keys);

  }

  getDevotionsForCurrentLocale(){
    this.devotionsMap = jsonDecode(box.get(UserService.instance.locale, defaultValue: "{}"));
  }

  Devotion getDevotionForDate(DateTime date) {

    print(date.toString());
    print(Jiffy.unix(date.millisecondsSinceEpoch).dayOfYear);
    //devotionsMap.forEach((key, value) {print(key); print(value.toString());});
    //return _devotion;
    print(devotionsMap.containsKey(Jiffy.unix(date.millisecondsSinceEpoch).dayOfYear.toString()));
    if(!devotionsMap.containsKey(Jiffy.unix(date.millisecondsSinceEpoch).dayOfYear.toString())) {
      throw DevotionNotFoundException("devotion_unavailable_desc".tr());
    }
    else {
      return Devotion.fromJson(devotionsMap[Jiffy
          .unix(date.millisecondsSinceEpoch)
          .dayOfYear.toString()]);
    }
  }

  saveDevotionForDate(String dayOfYear, Map<String, dynamic> data) {
    devotionsMap[dayOfYear] = data;
  }

  List<Devotion?> getDevotionsForWeek(DateTime startDate, DateTime endDate) {
    // return [
    //   _devotion,
    //   _devotion,
    //   _devotion,
    //   _devotion,
    //   _devotion,
    //   _devotion,
    //   _devotion
    // ];
    List<Devotion?> devotions =[];
    for(int day=0; day<7; day++) {
      try {
        devotions.add(getDevotionForDate(startDate.add(Duration(days: day))));
      }
      on DevotionNotFoundException catch(e){
        devotions.add(null);
      }
    }
    return devotions;
  }

  void saveDevotions(QuerySnapshot<Map<String, dynamic>> snapshots) {
    snapshots.docs.forEach((doc) {
      print(doc.data());
      DevotionService.instance.saveDevotionForDate(
          Jiffy(doc.data()['Date'], 'yyyy-MM-dd').dayOfYear.toString(),
          doc.data());
    });
    box.put(UserService.instance.locale, jsonEncode(devotionsMap));
    FirebaseCrashlytics.instance.setCustomKey('Devotion Size', devotionsMap.length);
  }
}
