import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:draw_near/services/author-service.dart';
import 'package:draw_near/services/carousel-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/song-service.dart';
import 'package:draw_near/services/theme-month-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/services/verse-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DownloadService {
  static final DownloadService instance = DownloadService._internal();

  DownloadService._internal();

  var _box = Hive.box('draw_near');
  late int localLastModified;
  late String downloadingLocale;
  late StreamSubscription _subscription;

  removeLocalLastModified() {
    _box.delete('lastModified');
  }

  Future<void> initialize() async {
    int retrievedDocCount = 0;
    _subscription = Connectivity().onConnectivityChanged.listen((event) async {
      if (event != ConnectivityStatus.none) {
        downloadingLocale = UserService.instance.locale;
        localLastModified = getLocalLastModified();
        print(DateTime.fromMillisecondsSinceEpoch(localLastModified)
            .difference(DateTime.now()));
        if (DateTime.now()
                .difference(
                    DateTime.fromMillisecondsSinceEpoch(localLastModified))
                .inMinutes <
            60) return;
        Fluttertoast.showToast(msg: "Checking for devotion updates");
        retrievedDocCount += await _downloadDevotions() ?? 0;
        retrievedDocCount += await _downloadSongs() ?? 0;
        retrievedDocCount += await _downloadVerses() ?? 0;
        retrievedDocCount += await _downloadAuthors() ?? 0;
        retrievedDocCount += await _downloadThemeMonths() ?? 0;
        await _downloadCarouselImages();
        if (retrievedDocCount > 0) {
          _box.put(
              'lastModified', DateTime.now().toUtc().millisecondsSinceEpoch);
          Fluttertoast.showToast(msg: "Update complete");
        } else
          Fluttertoast.showToast(msg: "No new updates");
        _subscription.cancel();
      }
    });
  }

  Future<int?> _downloadDevotions() async {
    QuerySnapshot<Map<String, dynamic>>? snapshots;

    ///iterate over months, fetch data from cloud and local and update the local data
    for (int monthIndex = 0; monthIndex < MONTHS_IN_YEAR.length; monthIndex++) {
      snapshots = await FirebaseFirestore.instance
          .collection('devotions')
          .doc(downloadingLocale)
          .collection(MONTHS_IN_YEAR[monthIndex])
          .where('Last Modified Time',
              isGreaterThanOrEqualTo: localLastModified - 3600000)
          .get();

      print('\n\n Devotions \n\n');
      DevotionService.instance.saveDevotions(snapshots);
    }
    return snapshots?.docs.length;
  }

  int getLocalLastModified() {
    return _box.get('lastModified',
        defaultValue: DateTime.utc(2020).millisecondsSinceEpoch);
  }

  Future<int?> _downloadSongs() async {
    var snapshots = await FirebaseFirestore.instance
        .collection('songs_$downloadingLocale')
        .where('Last Modified Time',
            isGreaterThanOrEqualTo: localLastModified - 3600000)
        .get();

    print('\n\n Songs \n\n');
    SongService.instance.saveSongs(snapshots);
    return snapshots.docs.length;
  }

  Future<int?> _downloadVerses() async {
    var snapshots = await FirebaseFirestore.instance
        .collection('verses_$downloadingLocale')
        .where('Last Modified Time',
            isGreaterThanOrEqualTo: localLastModified - 3600000)
        .get();

    print('\n\n Verses \n\n');
    VerseService.instance.saveVerses(snapshots);
    return snapshots.docs.length;
  }

  Future<int?> _downloadAuthors() async {
    var snapshots = await FirebaseFirestore.instance
        .collection('authors_$downloadingLocale')
        .where('Last Modified Time',
            isGreaterThanOrEqualTo: localLastModified - 3600000)
        .get();

    print('\n\n Authors \n\n');
    AuthorService.instance.saveAuthors(snapshots);
    return snapshots.docs.length;
  }

  Future<int?> _downloadThemeMonths() async {
    ///iterate over months, fetch data from cloud and local and update the local data
    var snapshots = await FirebaseFirestore.instance
        .collection('themeMonth_$downloadingLocale')
        .where('Last Modified Time',
            isGreaterThanOrEqualTo: localLastModified - 3600000)
        .get();

    print('\n\n Theme months \n\n');
    print(localLastModified);
    print(snapshots.docs.length);
    ThemeMonthService.instance.saveThemeMonths(snapshots);
    return snapshots.docs.length;
  }

  Future<int?> _downloadCarouselImages() async {
    ///iterate over months, fetch data from cloud and local and update the local data
    var docSnap = await FirebaseFirestore.instance
        .collection('common')
        .doc('carouselImages_$downloadingLocale')
        .get();

    print('\n\n Carousel Images \n\n');
    print(localLastModified);
    CarouselImageService.instance.saveCarouselImages(docSnap);
    return 0;
  }
}
