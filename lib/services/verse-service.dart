import 'dart:convert';

import 'package:draw_near/models/verse.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VerseService {
  var box = Hive.box('draw_near');
  late Map<String, dynamic> versesMap;

  Verse _verse = Verse(
      "rec",
      "Who am I, O Lord God? And what is my house, that You have brought me this far? (v. 21b)",
      'Whenever our Lord Jesus Christ was moved with compassion, He did something miraculous! The scene of the widow weeping for the loss of her son moved the Lord with compassion which compelled Him into action and therefore He raised the dead man alive and presented him to his mother. Fear came upon all who witnessed this great miracle of a dead man coming back to life. The true definition of compassion involves a tangible expression of love for those who are suffering. It gives us the ability to understand someone’s struggle and it creates a desire to take action to alleviate their suffering. It is the most powerful force in the world; it benefits both those who receive it and those who share it. Christ when He walked on this earth was filled with compassion for the people, and He wants us also to feel the same divine power. Real life Events: Ida Scudder the woman who grew up in India and couldn’t wait to leave, one night witnessed the death of three women in labor as their husbands refused the help of her father who was a doctor due to the social taboo that existed at that time. Seeing the plight of the women folks of our country, Ida was moved with compassion and so pursued medical studies abroad. She came back to India and served the Lord by founding a teaching hospital, in which women were admitted and trained in medical studies. She brought a huge change in the lives of so many women. Adopt and Apply: Developing a heart for compassion begins in families. When parents lead a compassionate life, children will naturally witness the powerful changes that this attribute brings in their lives and will assume its importance for their lives. Let the power of compassion flow from our families to the society thereby bringing glory to His kingdom.',
      ["rec"],
      12345678);

  static final VerseService instance = VerseService._internal();
  factory VerseService() {
    return instance;
  }
  VerseService._internal(){
    this.versesMap = jsonDecode(box.get('verses_${UserService.instance.locale}', defaultValue: '{}'));

  }

  Verse getVerse(String recordId) {
    //return _verse;
    return Verse.fromJson(versesMap[recordId]);
  }

  void saveVerse(String recordId, Map<String, dynamic> data) {
    versesMap[recordId] = data;
    box.put('verses_${UserService.instance.locale}', jsonEncode(versesMap));
  }

}
