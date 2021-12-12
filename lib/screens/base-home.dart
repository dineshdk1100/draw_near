import 'package:draw_near/screens/calendar.dart';
import 'package:draw_near/screens/home.dart';
import 'package:draw_near/screens/settings.dart';
import 'package:draw_near/util/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BaseHome extends StatefulWidget {
  const BaseHome({Key? key}) : super(key: key);

  @override
  _BaseHomeState createState() => _BaseHomeState();
}

class _BaseHomeState extends State<BaseHome> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  Color navBarColor = Colors.white;
  Color inactiveColor = Colors.black38;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).platformBrightness.toString());
    Theme.of(context).brightness == Brightness.dark ? navBarColor = Colors.black54 : navBarColor = Colors.white;
    Theme.of(context).brightness == Brightness.dark ? inactiveColor = Colors.white70 : navBarColor = Colors.black38;

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Color(0xFFE87E7E), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: false, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.white,
        //colorBehindNavBar: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      CalendarPage(),
      Settings(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.today),
        title: ("Calendar"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: ("Account"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: inactiveColor,
      ),
    ];
  }
}
