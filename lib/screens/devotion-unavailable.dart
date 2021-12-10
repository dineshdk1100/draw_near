import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class DevotionUnavailable extends StatelessWidget {
  final String message;
  const DevotionUnavailable(this.message) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(message.tr())
          ],
        ),
      ),
    );
  }
}
