import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/author-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/song-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/services/verse-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';

class DownloadService {
  static final DownloadService instance = DownloadService._internal();

  DownloadService._internal();

  var _box = Hive.box('draw_near');
  late int localLastModified;
  late String downloadingLocale;

  initialize() async {
    downloadingLocale = UserService.instance.locale;
    localLastModified = getLocalLastModified();
    await _downloadDevotions();
    await _downloadSongs();
    await _downloadVerses();
    await _downloadAuthors();
    _box.put('lastModified', DateTime.now().toUtc().millisecondsSinceEpoch);
  }

  _downloadDevotions() async {
    //Timestamp cloudLastModified = await getCloudLastModified();

    ///iterate over months, fetch data from cloud and local and update the local data
    for (int monthIndex = 0; monthIndex < MONTHS_IN_YEAR.length; monthIndex++) {
      var snapshots = await FirebaseFirestore.instance
          .collection('devotions')
          .doc(downloadingLocale)
          .collection(MONTHS_IN_YEAR[monthIndex])
          .where('Last Modified Time',
              isGreaterThanOrEqualTo: localLastModified - 86400000)
          .get();

      print('\n\n Devotions \n\n');
      snapshots.docs.forEach((doc) {
        print(doc.data());
        DevotionService.instance.saveDevotionForDate(
            Jiffy(doc.data()['Date'], 'yyyy-MM-dd').dayOfYear.toString(),
            doc.data());
      });
    }
  }

  int getLocalLastModified() {
    return _box.get('lastModified',
        defaultValue: DateTime.utc(2020).millisecondsSinceEpoch);
  }

  _downloadSongs() async {
    var snapshots = await FirebaseFirestore.instance
        .collection('songs_$downloadingLocale')
        .where('Last Modified Time',
            isGreaterThanOrEqualTo: localLastModified - 86400000)
        .get();

    print('\n\n Songs \n\n');
    snapshots.docs.forEach((doc) {
      print(doc.data());
      SongService.instance.saveSong(doc.id, doc.data());
    });
  }

   _downloadVerses() async {
    var snapshots = await FirebaseFirestore.instance
        .collection('verses_$downloadingLocale')
        .where('Last Modified Time',
        isGreaterThanOrEqualTo: localLastModified - 86400000)
        .get();

    print('\n\n Verses \n\n');
    snapshots.docs.forEach((doc) {
      print(doc.data());
      VerseService.instance.saveVerse(doc.id, doc.data());
    });
  }

   _downloadAuthors() async {
    var snapshots = await FirebaseFirestore.instance
        .collection('authors_$downloadingLocale')
        .where('Last Modified Time',
        isGreaterThanOrEqualTo: localLastModified - 86400000)
        .get();

    print('\n\n Authors \n\n');
    snapshots.docs.forEach((doc) {
      print(doc.data());
      AuthorService.instance.saveAuthor(doc.id, doc.data());
    });
  }
}
