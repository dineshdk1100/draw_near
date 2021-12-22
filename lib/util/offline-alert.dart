import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';

isUserOffline(context) async {
  if (await Connectivity().checkConnectivity() == ConnectivityStatus.none) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('You are offline'),
              content: Text("Please connect to the internet and try again"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OKAY'))
              ],
            ));
    return true;
  }
  return false;
}
