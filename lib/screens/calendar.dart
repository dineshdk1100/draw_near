import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'devotion.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime weekStartDate;
  late DateTime weekEndDate;
  List<Devotion> devotions = [];

  @override
  void initState() {
    getCurrentWeek();
    super.initState();
  }

  getCurrentWeek(){
    setState(() {
      weekStartDate =
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      weekEndDate = DateTime.now()
          .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));
      devotions = DevotionService.instance
          .getDevotionsForWeek(weekStartDate, weekEndDate);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: getPreviousWeek,
        ),
        title: Text( Jiffy([weekStartDate.year, weekStartDate.month, weekStartDate.day]).MMMM, style: Theme.of(context).textTheme.headline6,),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.restart_alt_outlined,
            ),
            onPressed: getCurrentWeek,
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: getNextWeek,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            return DayCard(weekStartDate.add(Duration(days: index)),
                devotions[index].title);
          }),
    );
  }

  getPreviousWeek() {
    print("hi");
    setState(() {
      weekStartDate = weekStartDate.subtract(Duration(days: 7));
      weekEndDate = weekEndDate.subtract(Duration(days: 7));
      devotions = DevotionService.instance
          .getDevotionsForWeek(weekStartDate, weekEndDate);
    });
  }

  getNextWeek() {
    setState(() {
      weekStartDate = weekStartDate.add(Duration(days: 7));
      weekEndDate = weekEndDate.add(Duration(days: 7));
      devotions = DevotionService.instance
          .getDevotionsForWeek(weekStartDate, weekEndDate);
    });
  }
}

class DayCard extends StatelessWidget {
  DateTime date;
  String devotionTitle;
  DayCard(this.date, this.devotionTitle);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              Jiffy([date.year, date.month, date.day]).E.toUpperCase(),
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        title: Card(
          child: Container(
            padding: EdgeInsets.all(16),
            height: date.day == DateTime.now().day ? 72 : 56,
            alignment: Alignment.centerLeft,
            child: Text(devotionTitle, style: Theme.of(context).textTheme.subtitle1,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //border: date.day != DateTime.now().day ? Border.all(color:Colors.black45 ): Border.all(color: Colors.transparent),
              color: date.day == DateTime.now().day
                  ? Color(pastelThemePrimaryValue)
                  : Colors.black12,
            ),
          ),
        ),
        onTap: date.day > DateTime.now().day
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('devotion_denied'.tr()),
                ));
              }
            : () {
                navigateToDevotionPage(context);
              });
  }

  void navigateToDevotionPage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DevotionPage(DateTime.now())));
  }
}
