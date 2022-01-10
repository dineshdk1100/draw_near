import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:draw_near/util/helper.dart';
import 'package:easy_localization/easy_localization.dart';
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
  DateTime selectedDate = DateTime.now();
  List<Devotion?> devotions = [];

  @override
  void initState() {
    getCurrentWeek();
    super.initState();
  }

  getCurrentWeek() {
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onOpenDatePicker,
        label: Text('select_date'.tr()),
        icon: Icon(Icons.today),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: getPreviousWeek,
        ),
        title: Text(
          DateFormat("MMMM", context.locale.languageCode).format(weekEndDate),
          style: Theme.of(context).textTheme.headline6,
        ),
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
                devotions[index]?.title ?? "devotion_unavailable".tr());
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

  void onOpenDatePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(selectedDate.year, 1, 1),
        lastDate: DateTime(selectedDate.year, 12, 31),
        selectableDayPredicate: (DateTime date) {
          if (date.isSameDayAs(DateTime.now())) return true;
          return DevotionService.instance.devotionsMap.containsKey(
              Jiffy.unix(date.millisecondsSinceEpoch).dayOfYear.toString());
        });
    if (date != null) {
      if (Jiffy.unix(date.millisecondsSinceEpoch).dayOfYear >
          Jiffy.unix(DateTime.now().millisecondsSinceEpoch).dayOfYear) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('devotion_denied'.tr()),
        ));
        return;
      }
      selectedDate = date;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DevotionPage(date)));
    }
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
              getFormattedWeekDay(date, context.locale.languageCode)
                  .toUpperCase(),
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        title: Card(
          child: Container(
            padding: EdgeInsets.all(16),
            height: date.isSameDayAs(DateTime.now()) ? 72 : 56,
            alignment: Alignment.centerLeft,
            child: Text(
              devotionTitle,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: date.isAfter(DateTime.now())
                      ? Theme.of(context).textTheme.caption?.color
                      : Theme.of(context).textTheme.subtitle1?.color),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //border: date.day != DateTime.now().day ? Border.all(color:Colors.black45 ): Border.all(color: Colors.transparent),
              color: date.isSameDayAs(DateTime.now())
                  ? Color(pastelThemePrimaryValue)
                  : Colors.black12,
            ),
          ),
        ),
        onTap: Jiffy.unix(date.millisecondsSinceEpoch).dayOfYear >
                Jiffy.unix(DateTime.now().millisecondsSinceEpoch).dayOfYear
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('devotion_denied'.tr()),
                ));
              }
            : devotionTitle == "devotion_unavailable".tr()
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Devotion not available for the selected date")));
                  }
                : () {
                    navigateToDevotionPage(context, date);
                  });
  }

  void navigateToDevotionPage(context, DateTime date) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DevotionPage(date)));
  }
}

getFormattedWeekDay(DateTime date, String locale) {
  return DateFormat("E", locale).format(date);
}
