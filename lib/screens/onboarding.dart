import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:draw_near/services/animated_indicator.dart';
import 'package:draw_near/screens/login.dart';

const blue = Color(0xFF4781ff);
const kTitleStyle = TextStyle(
    fontSize: 30, color: Color(0xFF01002f), fontWeight: FontWeight.bold);
const kSubtitleStyle = TextStyle(fontSize: 22, color: Color(0xFF88869f));
//ignore: must_be_immutable
class Boarding extends StatelessWidget {
  PageController pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Slide(
                      hero: Image.asset("./assets/images/sample_3.jpeg"),
                      title: "DRAW NEAR",
                      subtitle:
                      "A Family Daily Devotion application",
                      onNext: nextPage),
                  Slide(
                      hero: Image.asset("./assets/images/sample_3.jpeg"),
                      title: "JESUS",
                      subtitle:
                      "Sample text Sample text Sample text Sample text Sample text Sample text Sample text",
                      onNext: nextPage),
                  Slide(
                      hero: Image.asset("./assets/images/sample_3.jpeg"),
                      title: "BIBLE",
                      subtitle:
                      "Sample text Sample text Sample text Sample text Sample text Sample text Sample text",
                      onNext: nextPage),
                  Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(

                    ),
                  )
                ])),
      ),
    );
  }

  void nextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

}

class Slide extends StatelessWidget {
  final Widget hero;
  final String title;
  final String subtitle;
  final VoidCallback onNext;

  const Slide({Key? key,  required this.hero, required this.title, required this.subtitle, required this.onNext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: hero),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  title,
                  style: kTitleStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  subtitle,
                  style: kSubtitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 35,
                ),
                ProgressButton(onNext: onNext),
              ],
            ),
          ),
          GestureDetector(
            onTap: onNext,
            child: Text(
              "Skip",
              style: kSubtitleStyle,
            ),
          ),
          SizedBox(
            height: 4,
          )
        ],
      ),
    );
  }
}

class ProgressButton extends StatelessWidget {
  final VoidCallback onNext;
  const ProgressButton({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Stack(children: [
        AnimatedIndicator(
          duration: const Duration(seconds: 10),
          size: 75,
          callback: onNext,
        ),
        Center(
          child: GestureDetector(
            child: Container(
              height: 60,
              width: 60,
              child: Center(
                child: SvgPicture.asset(
                  "./assets/images/arrow.svg",
                  width: 10,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [
                        Colors.pinkAccent,
                        Colors.pink,
                        Colors.pinkAccent,
                        //Colors.red,
                      ]
                  )),
            ),
            onTap: onNext,

          ),
        )
      ]),

    );
  }

}
