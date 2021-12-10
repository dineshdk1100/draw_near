import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:draw_near/util/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';


class DownloadService {
  DevotionService devotionService = DevotionService.instance;
  var box = Hive.box('draw_near');
  downloadDevotions() async {
    int localLastModified = getLocalLastModified();
    //Timestamp cloudLastModified = await getCloudLastModified();

    ///iterate over months, fetch data from cloud and local and update the local data
    for (int monthIndex = 0; monthIndex < MONTHS_IN_YEAR.length; monthIndex++) {
      var snapshots = await FirebaseFirestore.instance
          .collection('devotions').doc(UserService.instance.locale)
          .collection(MONTHS_IN_YEAR[monthIndex])
          .where('Last Modified Time',
              isGreaterThanOrEqualTo: localLastModified - 86400000)
          .get();

      snapshots.docs.forEach((doc) {
        DevotionService.instance.setDevotionForDate(Jiffy(doc.data()['Date'], 'yyyy-MM-dd').dayOfYear.toString(), doc.data());});
      }

    box.put('lastModified',DateTime.now());

  }

  // Future<Timestamp> getCloudLastModified() async {
  //   var snapshot =
  //       await FirebaseFirestore.instance.collection('utils').doc('util').get()
  //         ..data();
  //   return snapshot.get('lastModified');
  // }

  int getLocalLastModified() {
    return box.get('lastModified', defaultValue: DateTime.utc(2020));
  }
}
