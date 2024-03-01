import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Utils/app_colors.dart';
import 'View/Chat/chat.dart';
import 'View/Home/home.dart';
import 'View/Notices/pharmacy.dart';
import 'View/profile/lodged_in_profile.dart';
import 'View/profile/profile.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({Key? key}) : super(key: key);

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _bottomNavIndex = 2;

  List<IconData> icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.comments,
    FontAwesomeIcons.houseMedical,
    FontAwesomeIcons.gear,
  ];

  List<Widget> pages = [
    const Home(),
    const Chat(),
    const Pharmacy(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: pages[_bottomNavIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        shadow: BoxShadow(
          color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, -15),
          blurRadius: 10
        ),
        icons: icons,
        notchSmoothness: NotchSmoothness.softEdge,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.none,
        iconSize: 19.sp,
        inactiveColor: Colors.grey,
        activeColor: primaryColor,
        leftCornerRadius: 40.sp,
        rightCornerRadius: 40.sp,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}