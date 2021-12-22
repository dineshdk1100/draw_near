import 'dart:async';

import 'package:draw_near/screens/initializer.dart';
import 'package:draw_near/screens/login.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:draw_near/screens/onboard_content.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
    /*Timer.periodic(Duration(seconds: 15), (Timer timer) {
      if (currentIndex < 2) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      _controller.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });*/
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10),
                        child: Image.asset(
                          contents[i].image,
                          height: 230,
                        ),),
                    Text(
                          contents[i].title,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                new Expanded(child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: new Text(
                          contents[i].description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 18,
                            //color: Colors.black54,
                          ),
                        )
                ),),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),


          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),


          Container(
            height: 60,
            margin: EdgeInsets.all(30),
            width: double.infinity,
            child: FlatButton(
              child: Text(
                  currentIndex == contents.length - 1 ? "Continue" : "Next"),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => Initializer(),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
              //color: Colors.blue.shade100,
              //textColor: Colors.black,
              color: Color(pastelThemePrimaryValue),
              //textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}