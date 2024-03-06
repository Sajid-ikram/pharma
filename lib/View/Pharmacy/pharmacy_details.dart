import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma/View/Pharmacy/pharmasist_list.dart';

import '../profile/sub_page/admin_panel.dart';

class PharmacyDetail extends StatefulWidget {
  PharmacyDetail({super.key, this.data});

  QueryDocumentSnapshot<Object?>? data;

  @override
  State<PharmacyDetail> createState() => _PharmacyDetailState();
}

class _PharmacyDetailState extends State<PharmacyDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data?["pharmacyName"],
            style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.only(left: 10.w),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description: ${widget.data?["description"]}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Address: ${widget.data?["address"]}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Workers:",
                    style:
                        TextStyle(fontSize: 16.0,),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200.h,
              child: PharmasistList(
                pharmacyId: widget.data?.id ?? "",
                creatorId: widget.data?["ownerUid"],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
