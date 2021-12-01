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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _devotion = DevotionService.instance.getDevotionsForDate(widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    TextStyle? subtitle1 = Theme.of(context).textTheme.subtitle1?.copyWith(
        fontSize: (Theme.of(context).textTheme.subtitle1!.fontSize!.toDouble() +
            UserService.instance.fontSize));
    TextStyle? subtitle2 = Theme.of(context).textTheme.subtitle2?.copyWith(
        fontSize: (Theme.of(context).textTheme.subtitle2!.fontSize!.toDouble() +
            UserService.instance.fontSize));
    TextStyle? headline4 = Theme.of(context).textTheme.headline4?.copyWith(
        fontSize: (Theme.of(context).textTheme.headline4!.fontSize!.toDouble() +
            UserService.instance.fontSize));
    TextStyle? quote = Theme.of(context).textTheme.bodyText2?.copyWith(
        color: Colors.black54,
        fontSize: (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
            UserService.instance.fontSize));
    TextStyle? author = Theme.of(context).textTheme.bodyText2?.copyWith(
        color: Colors.pinkAccent[200],
        fontSize: (Theme.of(context).textTheme.subtitle2!.fontSize!.toDouble() +
            UserService.instance.fontSize));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
              onPressed: () {
                onFontSizeDecrease();
              },
              icon: Icon(Icons.zoom_out)),
          IconButton(
            onPressed: () {
              onFontSizeIncrease();
            },
            icon: Icon(
              Icons.zoom_in,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            _devotion.title,
            style: headline4,
            textAlign: TextAlign.center,
          ),
          Divider(),
          Text(
            "2, November 2021",
            textAlign: TextAlign.center,
            //_devotion.timestamp.toIso8601String(),
            style: subtitle1,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Author",
                //_devotion.timestamp.toIso8601String(),
                style: subtitle2,
              ),
              Text(
                _devotion.authorName,
                style: author,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'song'.tr(),
                //_devotion.timestamp.toIso8601String(),
                style: subtitle2,
              ),
              Text(
                _devotion.songNumber,
                style: subtitle1,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bible Portion",
                //_devotion.timestamp.toIso8601String(),
                style: subtitle2,
              ),
              Text(
                _devotion.biblePortion,
                style: subtitle1,
              ),
            ],
          ),
          SizedBox(height: 16),
          DevotionCard(_devotion.verseLine, Color(0xFFF1D1D1)),
          SizedBox(height: 16),
          DevotionCard(_devotion.body, Color(0xFFDCD6F7)),
          SizedBox(height: 16),
          DevotionCard(_devotion.reflectRespond, Color(0xFFDDFFBC)),
          SizedBox(height: 16),
          DevotionCard(_devotion.prayer, Color(0xFFFBC6A4)),
          SizedBox(height: 16),
          _devotion.quote != null
              ? ListTile(
                  minLeadingWidth: 20,
                  leading: Container(
                    width: 5,
                    color: Colors.grey,
                    //padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  subtitle: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _devotion.quote ?? "",
                          textAlign: TextAlign.justify,
                          style: quote,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          _devotion.quoteAuthor ?? "",
                          style: author,
                        )
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  // void showFontSizeDialog(context) {
  //   _scaffoldKey.currentState?.showBottomSheet(
  //     (context) => Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Text("change_font_size"),
  //         Container(
  //           height: 150,
  //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
  //           child: Center(
  //             child: Slider(
  //               value: UserService.instance.fontSize,
  //               onChanged: onFontSizeChange,
  //               divisions: 5,
  //               min: 0,
  //               max: 10,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void onFontSizeIncrease() {
    setState(() {
      UserService.instance.fontSize += 2;
    });
  }

  void onFontSizeDecrease() {
    setState(() {
      UserService.instance.fontSize -= 2;
    });
  }
}

class DevotionCard extends StatelessWidget {
  final String content;
  final Color color;
  DevotionCard(this.content, this.color);

  @override
  Widget build(BuildContext context) {
    TextStyle? bodyText = Theme.of(context).textTheme.bodyText2?.copyWith(
        fontSize: (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
            UserService.instance.fontSize));
    return Card(
      child: Container(
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        //color: color,
        padding: EdgeInsets.all(12),
        child: Text(
          content,
          style: bodyText,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
