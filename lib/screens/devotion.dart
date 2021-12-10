import 'package:draw_near/exceptions/devotion-not-found.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/screens/devotion-unavailable.dart';
import 'package:draw_near/screens/song-details.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'author-details.dart';

class DevotionPage extends StatefulWidget {
  final DateTime date;
  DevotionPage(this.date);

  @override
  _DevotionPageState createState() => _DevotionPageState();
}

class _DevotionPageState extends State<DevotionPage> {
  late Devotion _devotion;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Brightness platformBrightness;
  List<bool> isSelected = [false, true];
  @override
  void initState() {
    try {
      _devotion = DevotionService.instance.getDevotionsForDate(widget.date);
    }
    on DevotionNotFoundException catch(e) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DevotionUnavailable(e.message)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    platformBrightness = MediaQuery.of(context).platformBrightness;
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    TextStyle? bodyText2 = GoogleFonts.robotoSlab(
        textStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontSize:
                (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
                    UserService.instance.fontSize)));
    TextStyle? subtitle2 = GoogleFonts.roboto(
        textStyle: Theme.of(context).textTheme.subtitle2?.copyWith(
            fontSize:
                (Theme.of(context).textTheme.subtitle2!.fontSize!.toDouble() +
                    UserService.instance.fontSize)));
    TextStyle? headline4 = GoogleFonts.scopeOne(
        textStyle: Theme.of(context).textTheme.headline4?.copyWith(
          fontWeight: FontWeight.w600,
            fontSize:
                (Theme.of(context).textTheme.headline5!.fontSize!.toDouble() +
                    UserService.instance.fontSize)));
    TextStyle? quote = GoogleFonts.lora(
        textStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontSize:
                (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
                    UserService.instance.fontSize),
            fontStyle: FontStyle.italic));
    TextStyle? author = GoogleFonts.robotoSlab(
        textStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
            color: Colors.pinkAccent[200],
            fontSize:
                (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
                    UserService.instance.fontSize)));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          ToggleButtons(
              fillColor: Colors.transparent,
              renderBorder: false,
              children: [
                Icon(Icons.menu),
                Icon(Icons.reorder),
              ],
              onPressed: (index) => setState(() {
                if (index == 0) UserService.instance.bodyTextStyleHeight = 1.7;
                else UserService.instance.bodyTextStyleHeight = 1.5;
                    for (int i = 0; i < isSelected.length; i++)
                      if (i == index)
                        isSelected[i] = true;
                      else
                        isSelected[i] = false;
                  }),
              isSelected: isSelected),
          VerticalDivider(width: 32, indent: 10, endIndent: 10,),
            IconButton(

                onPressed: UserService.instance.fontSize <= -2 ? null :() {
                  onFontSizeDecrease();
                },
                icon: Icon(MdiIcons.formatFontSizeDecrease)),
            IconButton(
              onPressed: UserService.instance.fontSize >=10 ? null :() {
                onFontSizeIncrease();
              },
              icon: Icon(
                MdiIcons.formatFontSizeIncrease,
              ),
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Text(
            _devotion.title,
            style: headline4,
            textAlign: TextAlign.center,
          ),
          Divider(),
          Text(getFormattedDate(_devotion.date, context.locale.languageCode),
            //"2, November 2021",
            textAlign: TextAlign.center,
            //_devotion.timestamp.toIso8601String(),
            style: bodyText2,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "author".tr(),
                //_devotion.timestamp.toIso8601String(),
                style: subtitle2,
              ),
              TextButton.icon(
                icon: Icon(Icons.launch),
                label: Text(
                  _devotion.authorName,
                  style: author,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AuthorDetails(_devotion.author[0]))),
              ),

            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'song'.tr(),
                //_devotion.timestamp.toIso8601String(),
                style: subtitle2,
              ),
              TextButton.icon(
                icon: Icon(Icons.launch),
                label: Text(
                  _devotion.songNumber,
                  style: bodyText2,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SongDetails(_devotion.song[0]))),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "bible_portion".tr(),
                //_devotion.timestamp.toIso8601String(),
                style: subtitle2,
              ),
              Text(
                _devotion.biblePortion,
                style: bodyText2,
              ),
            ],
          ),
          SizedBox(height: 16),
          DevotionCard(
              _devotion.verseLine,
              platformBrightness == Brightness.light
                  ? HSLColor.fromColor(Color(0xFFe6adad)).withLightness(0.9).toColor()
                  : Color(0xFFd98282)),
          SizedBox(height: 16),
          DevotionCard(
              _devotion.body,
              platformBrightness == Brightness.light
                  ? Color(0xFFDDFFBC)
                  : Color(0xFF4d9900)),
          SizedBox(height: 16),
          DevotionCard(
              _devotion.reflectRespond,
              platformBrightness == Brightness.light
                  ? Color(0xFFFBC6A4)
                  : Color(0xFFf7833b)),
          SizedBox(height: 16),
          DevotionCard(
              _devotion.prayer,
              platformBrightness == Brightness.light
                  ? Color(0xFFDCD6F7)
                  : Color(0xFF927fe6)),

          SizedBox(height: 16),
          _devotion.quote != null
              ? ListTile(isThreeLine: true,
                  minLeadingWidth: 16,
                  leading: Container(
                    width: 5,
                    color: Colors.black38,
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
                          _devotion.quoteAuthor,
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
    TextStyle? bodyText = GoogleFonts.robotoSlab(
        textStyle: Theme.of(context).textTheme.bodyText2?.copyWith(height: UserService().bodyTextStyleHeight,
            fontSize:
                (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
                    UserService.instance.fontSize)));
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

getFormattedDate(DateTime date, String locale ){
  return DateFormat( "dd, MMMM yyyy",locale).format(date);
}
