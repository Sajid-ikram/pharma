import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/Utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../Provider/search_provider.dart';

Align buildSearch(BuildContext context, String page) {
  var pro = Provider.of<SearchProvider>(context, listen: false);
  TextEditingController controller = TextEditingController(text: pro.getText(page));
  return Align(
    alignment: const Alignment(0, -0.95),
    child: Container(
      height: 50.h,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 4,
            blurRadius: 14,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            child: Icon(
              Icons.search,
              color: Colors.grey,
              size: 24.sp,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                if (page == "user") {
                  Provider.of<SearchProvider>(context, listen: false)
                      .searchUser(value);
                } else if (page == "pharmacy") {
                  Provider.of<SearchProvider>(context, listen: false)
                      .searchPharmacy(value);
                }else if (page == "notice") {
                  Provider.of<SearchProvider>(context, listen: false)
                      .searchNotice(value);
                }
              },

              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3.h),
                border: InputBorder.none,
                focusColor: primaryColor,

                /*prefixIcon: Icon(
                  Icons.search,
                  size: 24.sp,
                ),*/
                hintText: "Search here",
                hintStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
