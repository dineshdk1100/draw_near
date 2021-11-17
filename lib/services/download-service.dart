import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box('draw_near');

class DownloadService {
  DevotionService devotionService = DevotionService.instance;

  downloadDevotions() async {
    DateTime localLastModified = getLocalLastModified();
    Timestamp cloudLastModified = await getCloudLastModified();

    ///iterate over months, fetch data from cloud and local and update the local data
    for (int monthIndex = 0; monthIndex < MONTHS_IN_YEAR.length; monthIndex++) {
      var snapshots = await FirebaseFirestore.instance
          .collection('devotions').doc()
          .collection(MONTHS_IN_YEAR[monthIndex])
          .where('lastModified',
              isLessThanOrEqualTo: Timestamp.fromDate(localLastModified))
          .get();
      List<Devotion> devotions =
          devotionService.getDevotionsForMonth(MONTHS_IN_YEAR[monthIndex]);

      snapshots.docs.forEach((doc) =>
          devotions[int.parse(doc.id)] = Devotion.fromJson(doc.data()));
      box.put(MONTHS_IN_YEAR[monthIndex],
          devotions.map((d) => d.toJson()).toList());
    }
    box.put('lastModified', cloudLastModified.toDate());
  }

  Future<Timestamp> getCloudLastModified() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('utils').doc('util').get()
          ..data();
    return snapshot.get('lastModified');
  }

  DateTime getLocalLastModified() {
    return box.get('lastModified', defaultValue: DateTime.utc(2020));
  }
}
