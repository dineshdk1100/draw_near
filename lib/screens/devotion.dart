import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DevotionPage extends StatefulWidget {
  final DateTime date;
  DevotionPage(this.date);

  @override
  _DevotionPageState createState() => _DevotionPageState();
}

class _DevotionPageState extends State<DevotionPage> {
  late Devotion _devotion;
  @override
  void initState() {
    _devotion = DevotionService.instance.getDevotionsForDate(widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    TextStyle? bodyText = Theme.of(context)
        .textTheme
        .bodyText1
        ?.copyWith(fontSize: UserService.instance.fontSize);
    TextStyle? subtitle1 = Theme.of(context)
        .textTheme
        .subtitle1
        ?.copyWith(fontSize: UserService.instance.fontSize);
    TextStyle? subtitle2 = Theme.of(context)
        .textTheme
        .subtitle2
        ?.copyWith(fontSize: UserService.instance.fontSize);
    TextStyle? headline3 = Theme.of(context)
        .textTheme
        .headline3
        ?.copyWith(fontSize: UserService.instance.fontSize);
    TextStyle? quote = Theme.of(context).textTheme.bodyText2?.copyWith(
        color: Colors.black54, fontSize: UserService.instance.fontSize);
    TextStyle? author = Theme.of(context).textTheme.bodyText2?.copyWith(
        color: Colors.pinkAccent[200], fontSize: UserService.instance.fontSize);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
              onPressed: showFontSizeDialog, icon: Icon(Icons.text_fields))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            _devotion.title,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _devotion.timestamp.toString(),
                style: subtitle1,
              ),
              Text(
                _devotion.author,
                style: author,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'song'.tr() + _devotion.song,
                style: subtitle2,
              ),
              Text(
                _devotion.biblePortion,
                style: subtitle2,
              ),
            ],
          ),
          SizedBox(height: 16),
          DevotionCard(_devotion.verse, Color(0xFFF1D1D1)),
          SizedBox(height: 16),
          DevotionCard(_devotion.body, Color(0xFFDCD6F7)),
          SizedBox(height: 16),
          DevotionCard(_devotion.reflectRespond, Color(0xFFDDFFBC)),
          SizedBox(height: 16),
          DevotionCard(_devotion.prayer, Color(0xFFFBC6A4)),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 8,
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              Column(
                children: [
                  Text(_devotion.quote.body),
                  Text(
                    _devotion.quote.author,
                    style: author,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  void showFontSizeDialog() {
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Slider.adaptive(
            value: UserService.instance.fontSize,
            onChanged: onFontSizeChange,
            divisions: 5,
            min: 12,
            max: 48,
          ),
        ),
      ),
    );
  }

  void onFontSizeChange(double value) {
    UserService.instance.fontSize = value;
  }
}

class DevotionCard extends StatelessWidget {
  final String content;
  final Color color;
  DevotionCard(this.content, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: color,
        padding: EdgeInsets.all(12),
        child: Text(content),
      ),
    );
  }
}
