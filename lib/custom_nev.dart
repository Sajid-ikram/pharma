import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharma/View/Notices/lodged_in_notice.dart';

import 'Utils/app_colors.dart';
import 'View/Chat/chat_page.dart';
import 'View/Home/home.dart';
import 'View/Notices/notice_middle_page.dart';
import 'View/Pharmacy/pharmacy.dart';
import 'View/profile/profile.dart';
import 'View/profile/sub_page/profile_detail.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({Key? key}) : super(key: key);

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _bottomNavIndex = 0;

  List<IconData> icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.comments,
    FontAwesomeIcons.bell,
    FontAwesomeIcons.notesMedical,
    FontAwesomeIcons.gear,
  ];

  List<Widget> pages = [
    const Home(),
    const Chat(),
    const NoticeMiddlePage(),
    Pharmacy(),
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
            blurRadius: 10),
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
