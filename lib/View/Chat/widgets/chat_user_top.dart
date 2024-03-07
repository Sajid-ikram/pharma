import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/profile/sub_page/admin_panel.dart';

import '../../../Provider/profile_provider.dart';


import 'package:provider/provider.dart';
Padding chatTop(BuildContext context) {

  var pro = Provider.of<ProfileProvider>(context, listen: false);
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 30.sp),
    child: SizedBox(
      height: 40.h,
      width: 400.w,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Massage",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          pro.role == "admin" ? Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPanel(
                      isAdminPanel : false
                    ),
                  ),
                );
              },
              child: Icon(
                FontAwesomeIcons.users,
                size: 18.sp,
              ),
            ),
          ) : SizedBox(),
        ],
      ),
    ),
  );
}