import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw_near/exceptions/devotion-not-found.dart';
import 'package:draw_near/models/author.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/screens/song-details.dart';
import 'package:draw_near/screens/verse-details.dart';
import 'package:draw_near/services/author-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DevotionPage extends StatefulWidget {
  final DateTime date;
  DevotionPage(this.date);

  @override
  _DevotionPageState createState() => _DevotionPageState();
}

class _DevotionPageState extends State<DevotionPage> {
  late Devotion _devotion;
  late Author authors;
  bool isDevotionAvailable = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Brightness platformBrightness;
  List<bool> isSelected = [false, true];

  bool isAuthorAvailable = true;

  @override
  void initState() {
    print("in init stateee");
    try {
      _devotion = DevotionService.instance.getDevotionForDate(widget.date);
      print('check');
      print(_devotion);
      isDevotionAvailable = _devotion.title.trim().length != 0;
      authors = AuthorService.instance.getAuthor(_devotion.author[0]);
    } on DevotionNotFoundException catch (e) {
      print("devotion not found");
      isDevotionAvailable = false;
      //Fluttertoast.showToast(msg: e.message);
    } on AuthorNotFoundException catch (e) {
      isAuthorAvailable = false;
      print("author not found");
      //Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      isDevotionAvailable = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    platformBrightness = Theme.of(context).brightness;
    //final args = ModalRoute.of(context)!.settings.arguments as Map;
    TextStyle? bodyText2 = GoogleFonts.robotoSlab(
        textStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
              fontSize:
                  (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
                      UserService.instance.fontSize),
            ));
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
            fontSize:
                (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
                    UserService.instance.fontSize)));

    print(isDevotionAvailable);
    return isDevotionAvailable == true
        ? Scaffold(
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
                          if (index == 0)
                            UserService.instance.bodyTextStyleHeight = 1.7;
                          else
                            UserService.instance.bodyTextStyleHeight = 1.5;
                          for (int i = 0; i < isSelected.length; i++)
                            if (i == index)
                              isSelected[i] = true;
                            else
                              isSelected[i] = false;
                        }),
                    isSelected: isSelected),
                VerticalDivider(
                  width: 32,
                  indent: 10,
                  endIndent: 10,
                ),
                IconButton(
                    onPressed: UserService.instance.fontSize <= -2
                        ? null
                        : () {
                            onFontSizeDecrease();
                          },
                    icon: Icon(MdiIcons.formatFontSizeDecrease)),
                IconButton(
                  onPressed: UserService.instance.fontSize >= 10
                      ? null
                      : () {
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
                Image.asset(
                  'assets/images/logo_transparent.png',
                  height: 60,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  _devotion.title ?? "",
                  style: headline4,
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 0,
                ),
                TextButton.icon(
                  icon: Text(
                    getFormattedDate(
                            widget.date, context.locale.languageCode) ??
                        "",
                    textAlign: TextAlign.center,
                    style: bodyText2,
                  ),
                  label: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: onOpenDatePicker,
                ),
                //SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'song'.tr() + ':',
                          //_devotion.timestamp.toIso8601String(),
                          style: subtitle2,
                        ),
                        SizedBox(width: 1),
                        TextButton.icon(
                          label: Icon(Icons.open_in_new),
                          icon: Text(
                            '#' + _devotion.songNumber[0] ?? "",
                            style: bodyText2.copyWith(
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () =>
                              //pushNewScreen(context, screen: SongDetails(_devotion.song[0]), withNavBar: false),
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SongDetails(_devotion.song[0]))),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "bible_portion".tr() + ':',
                          //_devotion.timestamp.toIso8601String(),
                          style: subtitle2,
                        ),
                        SizedBox(width: 1),
                        TextButton.icon(
                          label: Icon(Icons.open_in_new),
                          icon: Text(
                            _devotion.biblePortion ?? "",
                            overflow: TextOverflow.fade,
                            style: bodyText2.copyWith(
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VerseDetails(_devotion.verse[0]))),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 10),
                DevotionCard(
                    _devotion.verseLine[0],
                    platformBrightness == Brightness.light
                        ? HSLColor.fromColor(Color(0xffe2a2e7))
                            .withLightness(0.9)
                            .withSaturation(0.55)
                            .toColor()
                        : HSLColor.fromColor(Color(0xffe2a2e7))
                            .withLightness(0.9)
                            .withSaturation(0.55)
                            .toColor()),
                SizedBox(height: 3),
                DevotionCard(
                    _devotion.body,
                    platformBrightness == Brightness.light
                        ? HSLColor.fromColor(Color(0xffbecde0))
                            .withLightness(0.9)
                            .withSaturation(0.55)
                            .toColor()
                        : HSLColor.fromColor(Color(0xffbecde0))
                            .withLightness(0.9)
                            .withSaturation(0.55)
                            .toColor()),
                SizedBox(height: 3),
                DevotionCard(
                    _devotion.reflectRespond,
                    platformBrightness == Brightness.light
                        ? HSLColor.fromColor(Color(0xFFEAD377))
                            .withLightness(0.83)
                            .withSaturation(0.75)
                            .toColor()
                        : HSLColor.fromColor(Color(0xFFECD98C))
                            .withLightness(0.8)
                            .withSaturation(0.75)
                            .toColor()),
                SizedBox(height: 3),
                DevotionCard(
                    _devotion.prayer,
                    platformBrightness == Brightness.light
                        ? HSLColor.fromColor(Color(0xFF8985F5))
                            .withLightness(0.85)
                            .withSaturation(0.55)
                            .toColor()
                        : HSLColor.fromColor(Color(0xFFCF88FC))
                            .withLightness(0.85)
                            .withSaturation(0.55)
                            .toColor()),

                SizedBox(height: 3),
                _devotion.quote != null
                    ? ListTile(
                        //isThreeLine: true,
                        minLeadingWidth: 10,
                        leading: Container(
                            width: 3,
                            color: Theme.of(context).textTheme.headline2?.color
                            //padding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                        title: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            text: _devotion.quote ?? "",
                            style: quote,
                            children: [
                              // TextSpan(text: '  - '),
                              TextSpan(text: '  '),
                              TextSpan(
                                text: _devotion.quoteAuthor ?? "",
                                style: GoogleFonts.roboto(
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "by".tr(),
                      //_devotion.timestamp.toIso8601String(),
                      style: subtitle2,
                    ),
                    TextButton.icon(
                        label: Icon(Icons.navigate_next),
                        icon: Text(
                          _devotion.authorName[0] ?? "",
                          style: author,
                        ),
                        onPressed: isAuthorAvailable
                            ? () => showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(60),
                                        topRight: Radius.circular(60))),
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    padding: EdgeInsets.all(16),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                          height: 300,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: CircleAvatar(
                                                radius: 120,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        authors.photo[0]
                                                            ['url'])),
                                          ),
                                          //child: CachedNetworkImage(imageUrl: author.photo[0]['url'],),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          authors.name,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.playfairDisplay(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          authors.description,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              height: 1.5),
                                          textAlign: TextAlign.justify,
                                        )
                                      ],
                                    ),
                                  );
                                })
                            : null
                        /*   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AuthorDetails(_devotion.author[0]))),*/
                        ),
                  ],
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('devotion_unavailable'.tr()),
            ),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.speaker_notes_off_outlined,
                    size: 180,
                    color: Theme.of(context).textTheme.caption?.color!,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "devotion_unavailable_desc".tr(),
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
  }

  void onOpenDatePicker() async {
    var date = await showDatePicker(
      context: context,
      initialDate: widget.date,
      firstDate: DateTime(widget.date.year, 1, 1),
      lastDate: DateTime(widget.date.year, 12, 31),
    );

    if (date != null) {
      if (Jiffy.unix(date.millisecondsSinceEpoch).dayOfYear >
          Jiffy.unix(DateTime.now().millisecondsSinceEpoch).dayOfYear) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('devotion_denied'.tr()),
        ));
        return;
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DevotionPage(date)));
    }
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
        textStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
            height: UserService.instance.bodyTextStyleHeight,
            fontSize:
                (Theme.of(context).textTheme.bodyText2!.fontSize!.toDouble() +
                    UserService.instance.fontSize),
            color: Colors.black));
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

getFormattedDate(DateTime date, String locale) {
  print(date);
  // DateTime ne = DateTime(DateTime.now().year, date.month, date.day);
  // print('dd');
  // print(ne);
  return DateFormat("dd, MMMM yyyy", locale).format(date);
}
