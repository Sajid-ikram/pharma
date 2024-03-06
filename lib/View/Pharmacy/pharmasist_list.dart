import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/Pharmacy/single_pharmasist.dart';
import '../../../Utils/app_colors.dart';

class PharmasistList extends StatefulWidget {
  PharmasistList({Key? key, required this.pharmacyId,required this.creatorId}) : super(key: key);

  String pharmacyId;
  String creatorId;

  @override
  _PharmasistListState createState() => _PharmasistListState();
}

class _PharmasistListState extends State<PharmasistList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        width: 414,
        height: 837,
        child: Column(
          children: [
            SizedBox(height: 25.h),
            Row(
              children: [
                Text(
                  "Name",
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 130.w,
                  child: Center(
                    child: Text(
                      "Action",
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            const Divider(
              thickness: 1,
              height: 0,
            ),
            SizedBox(height: 12.h),
              Expanded(child: SinglePharmasist(pharmacyId: widget.pharmacyId,creatorId: widget.creatorId,))
          ],
        ),
      ),
    );
  }
}
