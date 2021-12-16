import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class DevotionUnavailable extends StatelessWidget {
  final String message;
  const DevotionUnavailable(this.message) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(message.tr(), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
