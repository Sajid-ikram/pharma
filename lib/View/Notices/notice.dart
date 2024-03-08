import 'dart:ffi';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/Utils/app_colors.dart';
import 'package:pharma/Utils/custom_loading.dart';
import 'package:pharma/View/Notices/addNotice.dart';
import 'package:provider/provider.dart';

import '../../Provider/notice_provider.dart';
import '../../Provider/profile_provider.dart';
import '../Pharmacy/user_info.dart';

enum WhyFarther { delete, edit }

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  int size = 0;
  String page = "All Users";
  String databaseName = "notice";

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notice",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
        actions: [
          if (pro.role == "admin")
            Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 22.sp,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNotice(),
                    ),
                  );
                },
              ),
            )
        ],
      ),
      floatingActionButton: pro.role == "Admin"
          ? customFloatingActionButton(context, "Notice")
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Align(
          alignment: Alignment.bottomCenter,
          child: Consumer<NoticeProvider>(
            builder: (context, provider, child) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(databaseName)
                    .orderBy('dateTime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildLoadingWidget();
                  }

                  final data = snapshot.data;
                  if (data != null) {
                    size = data.size;
                  }
                  return SizedBox(
                    height: 800.h,
                    child: Column(
                      children: [
                        if (pro.role == "admin" || pro.role == "contractor")
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(30.w, 21.h, 30.w, 20.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      page = "All Users";
                                      databaseName = "notice";
                                    });
                                  },
                                  child: _buildButton(
                                      "All Users", page == "All Users"),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      page = "Contractor";
                                      databaseName = "contractorNotice";
                                    });
                                  },
                                  child: _buildButton(
                                      "Contractor", page == "Contractor"),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 350.w,
                                margin:
                                    EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
                                padding:
                                    EdgeInsets.fromLTRB(20.w, 21.h, 5, 20.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xffE3E3E3), width: 1),
                                ),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Text(
                                          "Admin Notice",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              height: 1.4,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        /*if (pro.currentUserUid ==
                                            data?.docs[index]["ownerUid"])
                                          Positioned(
                                            right: 0,
                                            child: PopupMenuButton<WhyFarther>(
                                              icon: const Icon(Icons.more_horiz),
                                              padding: EdgeInsets.zero,
                                              onSelected: (WhyFarther result) {
                                                if (result == WhyFarther.delete) {
                                                  _showMyDialog(context,
                                                      data?.docs[index].id ?? "");
                                                } else if (result == WhyFarther.edit) {
                                                  */ /* Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddNewPostPage(
                                                        page: "Home",
                                                        documentSnapshot:
                                                            data?.docs[index],
                                                      ),
                                                    ),
                                                  );*/ /*
                                                }
                                              },
                                              itemBuilder: (BuildContext context) =>
                                                  <PopupMenuEntry<WhyFarther>>[
                                                const PopupMenuItem<WhyFarther>(
                                                  value: WhyFarther.delete,
                                                  child: Text('Delete'),
                                                ),
                                                const PopupMenuItem<WhyFarther>(
                                                  value: WhyFarther.edit,
                                                  child: Text('Edit'),
                                                ),
                                              ],
                                            ),
                                          )*/
                                      ],
                                    ),
                                    SizedBox(height: 18.h),
                                    Padding(
                                      padding: EdgeInsets.only(right: 15.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Title: ${data?.docs[index]["postTitle"]}",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.inter(
                                              fontSize: 15.sp, height: 1.4),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 18.h),
                                    Padding(
                                      padding: EdgeInsets.only(right: 14.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data?.docs[index]["postText"],
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.inter(
                                              fontSize: 15.sp, height: 1.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: size,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, String id) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Notice'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to delete this notice'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Provider.of<NoticeProvider>(context, listen: false)
                  .deleteNotice(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Container _buildButton(String text, bool showBorder) {
  return Container(
    height: 50.h,
    width: 130.w,
    decoration: BoxDecoration(
      color: showBorder ? primaryColor : Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          color: showBorder ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

FloatingActionButton customFloatingActionButton(
    BuildContext context, String page) {
  return FloatingActionButton(
    onPressed: () {
      /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewPostPage(page: "Notice"),
      ),
    );*/
    },
    elevation: 11,
    backgroundColor: Colors.white,
    child: Container(
      height: 45.h,
      width: 45.h,
      decoration: BoxDecoration(
        border: Border.all(color: secondaryColor, width: 2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.add,
        color: primaryColor,
        size: 25.sp,
      ),
    ),
  );
}
