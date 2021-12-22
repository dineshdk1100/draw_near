import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/author-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/song-service.dart';
import 'package:draw_near/services/theme-month-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/services/verse-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';

class DownloadService {
  static final DownloadService instance = DownloadService._internal();

  DownloadService._internal();

  var _box = Hive.box('draw_near');
  late int localLastModified;
  late String downloadingLocale;

  removeLocalLastModified(){
    _box.delete('lastModified');
  }
  Future<void> initialize() async {
    downloadingLocale = UserService.instance.locale;
    localLastModified = getLocalLastModified();
    print(DateTime.fromMillisecondsSinceEpoch(localLastModified).difference(DateTime.now()));
    if(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(localLastModified)).inHours < 12)
      return;
    Fluttertoast.showToast(msg: "Checking for devotion updates");
    await _downloadDevotions();
    await _downloadSongs();
    await _downloadVerses();
    await _downloadAuthors();
    await _downloadThemeMonths();
    _box.put('lastModified', DateTime.now().toUtc().millisecondsSinceEpoch);
    Fluttertoast.showToast(msg: "Update complete");

  }

  _downloadDevotions() async {

    ///iterate over months, fetch data from cloud and local and update the local data
    for (int monthIndex = 0; monthIndex < MONTHS_IN_YEAR.length; monthIndex++) {
      var snapshots = await FirebaseFirestore.instance
          .collection('devotions')
          .doc(downloadingLocale)
          .collection(MONTHS_IN_YEAR[monthIndex])
          .where('Last Modified Time',
              isGreaterThanOrEqualTo: localLastModified - 3600000)
          .get();

      print('\n\n Devotions \n\n');
      DevotionService.instance.saveDevotions(snapshots);
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
            isGreaterThanOrEqualTo: localLastModified - 3600000)
        .get();

    print('\n\n Songs \n\n');
   SongService.instance.saveSongs(snapshots);
  }

   _downloadVerses() async {
    var snapshots = await FirebaseFirestore.instance
        .collection('verses_$downloadingLocale')
        .where('Last Modified Time',
        isGreaterThanOrEqualTo: localLastModified - 3600000)
        .get();

    print('\n\n Verses \n\n');
    VerseService.instance.saveVerses(snapshots);
  }

   _downloadAuthors() async {
    var snapshots = await FirebaseFirestore.instance
        .collection('authors_$downloadingLocale')
        .where('Last Modified Time',
        isGreaterThanOrEqualTo: localLastModified - 3600000)
        .get();

    print('\n\n Authors \n\n');
    AuthorService.instance.saveAuthors(snapshots);
  }

  _downloadThemeMonths() async {

    ///iterate over months, fetch data from cloud and local and update the local data
    for (int monthIndex = 0; monthIndex < MONTHS_IN_YEAR.length; monthIndex++) {
      var snapshots = await FirebaseFirestore.instance
          .collection('themeMonth_$downloadingLocale')
          .where('Last Modified Time',
          isGreaterThanOrEqualTo: localLastModified - 3600000)
          .get();

      print('\n\n Theme months \n\n');
      ThemeMonthService.instance.saveThemeMonths(snapshots);
    }
  }
}
