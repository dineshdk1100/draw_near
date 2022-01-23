import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';

class UpdateService {
  static final UpdateService instance = UpdateService._internal();
  bool later = false;
  late String storeName;
  late int versionNumber;

  UpdateService._internal() {
    RemoteConfig.instance.setDefaults({'android_version': 1, 'ios_version': 1});
  }
  initialize(context) async {
    if (later) return;

    await RemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(minutes: 15),
    ));
    RemoteConfig.instance.ensureInitialized().then((value) {
      RemoteConfig.instance.fetchAndActivate();
      if (Platform.isAndroid) {
        versionNumber = RemoteConfig.instance.getInt('android_version');
        storeName = 'Play store';
      } else {
        versionNumber = RemoteConfig.instance.getInt('ios_version');
        storeName = 'App store';
      }
      print(versionNumber);
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        int currentVersionNumber = int.parse(packageInfo.buildNumber);
        print(currentVersionNumber);
        if (versionNumber > currentVersionNumber)
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Update available'),
                    content: Text(
                        "A new version of Draw Near is available on $storeName. Please update your app for a better experience."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            StoreRedirect.redirect();
                          },
                          child: Text('UPDATE NOW')),
                      TextButton(
                          onPressed: () {
                            later = true;
                            Navigator.pop(context);
                          },
                          child: Text('LATER'))
                    ],
                  ));
      });
    });
  }
}
