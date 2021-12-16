import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/song.dart';
import 'package:draw_near/models/song.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SongService {
  var box = Hive.box('draw_near');
  late Map<String, dynamic> songsMap;

  Song _song = Song(
      "rec",

      'Truth for Today: Whenever our Lord Jesus Christ was moved with compassion, He did something miraculous! The scene of the widow weeping for the loss of her son moved the Lord with compassion which compelled Him into action and therefore He raised the dead man alive and presented him to his mother. Fear came upon all who witnessed this great miracle of a dead man coming back to life. The true definition of compassion involves a tangible expression of love for those who are suffering. It gives us the ability to understand someone’s struggle and it creates a desire to take action to alleviate their suffering. It is the most powerful force in the world; it benefits both those who receive it and those who share it. Christ when He walked on this earth was filled with compassion for the people, and He wants us also to feel the same divine power. Real life Events: Ida Scudder the woman who grew up in India and couldn’t wait to leave, one night witnessed the death of three women in labor as their husbands refused the help of her father who was a doctor due to the social taboo that existed at that time. Seeing the plight of the women folks of our country, Ida was moved with compassion and so pursued medical studies abroad. She came back to India and served the Lord by founding a teaching hospital, in which women were admitted and trained in medical studies. She brought a huge change in the lives of so many women. Adopt and Apply: Developing a heart for compassion begins in families. When parents lead a compassionate life, children will naturally witness the powerful changes that this attribute brings in their lives and will assume its importance for their lives. Let the power of compassion flow from our families to the society thereby bringing glory to His kingdom.',
      ['rec'],
      '1',
      "Song name",
      12345678);

  static final SongService instance = SongService._internal();
  SongService._internal(){
    getSongsForCurrentLocale();
  }

  getSongsForCurrentLocale(){
    this.songsMap = jsonDecode(box.get('songs_${UserService.instance.locale}', defaultValue: '{}'));
  }

  Song getSong(String recordId) {
    //return _song;
    return Song.fromJson(songsMap[recordId]);
  }

  void saveSong(String recordId, Map<String, dynamic> data){
    songsMap[recordId] = data;
  }

  void saveSongs(QuerySnapshot<Map<String, dynamic>> snapshots) {
    snapshots.docs.forEach((doc) {
      print(doc.data());
      SongService.instance.saveSong(doc.id, doc.data());
    });
    box.put('songs_${UserService.instance.locale}', jsonEncode(songsMap));
  }

}
