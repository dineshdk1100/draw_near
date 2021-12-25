import 'package:draw_near/models/theme_month.dart';
import 'package:draw_near/services/theme-month-service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeMonthDetails extends StatefulWidget {
  final String monthName;
  const ThemeMonthDetails(this.monthName) : super();

  @override
  State<ThemeMonthDetails> createState() => _ThemeMonthDetailsState();
}

class _ThemeMonthDetailsState extends State<ThemeMonthDetails> {
  late ThemeMonth themeMonth;

  @override
  void initState() {
    themeMonth = ThemeMonthService.instance.getThemeMonth(widget.monthName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
          child: Container(
            //decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            padding: EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              children: [

                Text(themeMonth.title ,style: GoogleFonts.abrilFatface(
                  textStyle: Theme.of(context).textTheme.headline4,
                ),),
                SizedBox(height: 24,),
                Text(themeMonth.description, style: GoogleFonts.montserrat( fontSize: 16, height: 1.5),)
              ],
            ),

          ),
        )
    );
  }
}


