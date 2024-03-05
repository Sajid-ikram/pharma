import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/Pharmacy/user_info.dart';
import 'package:provider/provider.dart';

import '../../Provider/pharmacy_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Utils/custom_loading.dart';
import 'add_new_post_page.dart';
import 'add_pharmacists.dart';

enum options { delete, edit, addPharmacists }

class Pharmacy extends StatefulWidget {
  const Pharmacy({Key? key}) : super(key: key);

  @override
  State<Pharmacy> createState() => _PharmacyState();
}

class _PharmacyState extends State<Pharmacy> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      body: Align(
          alignment: Alignment.bottomCenter,
          child: Consumer<PharmacyProvider>(
            builder: (context, provider, child) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("notice")
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
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 350.w,
                        margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
                        padding: EdgeInsets.fromLTRB(20.w, 21.h, 5, 20.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xffE3E3E3), width: 1),
                        ),
                        child: Column(
                          children: [
                            Text(data?.docs[index]["pharmacyName"],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(height: 18.h),
                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  data?.docs[index]["description"],
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                      fontSize: 15.sp, height: 1.4),
                                ),
                              ),
                            ),
                            Divider(
                              height: 20.h,
                            ),
                            Stack(
                              children: [
                                UserInfoOfAPost(
                                  uid: data?.docs[index]["ownerUid"],
                                  time: data?.docs[index]["dateTime"],
                                  address: data?.docs[index]["address"],
                                ),
                                if (pro.currentUserUid ==
                                    data?.docs[index]["ownerUid"])
                                  Positioned(
                                    right: 0,
                                    child: PopupMenuButton<options>(
                                      icon: const Icon(Icons.more_vert_rounded),
                                      padding: EdgeInsets.zero,
                                      onSelected: (options result) {
                                        if (result == options.delete) {
                                          _showMyDialog(context,
                                              data?.docs[index].id ?? "");
                                        } else if (result == options.edit) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddNewPostPage(
                                                documentSnapshot:
                                                    data?.docs[index],
                                              ),
                                            ),
                                          );
                                        } else if (result ==
                                            options.addPharmacists) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddPharmacists(),
                                            ),
                                          );
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<options>>[
                                        const PopupMenuItem<options>(
                                          value: options.delete,
                                          child: Text('Delete'),
                                        ),
                                        const PopupMenuItem<options>(
                                          value: options.edit,
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem<options>(
                                          value: options.addPharmacists,
                                          child: Text('Add Pharmacists'),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: size,
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
              Provider.of<PharmacyProvider>(context, listen: false)
                  .deleteNotice(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
