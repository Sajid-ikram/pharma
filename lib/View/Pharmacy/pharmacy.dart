import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/Provider/search_provider.dart';
import 'package:pharma/Utils/app_colors.dart';
import 'package:pharma/View/Pharmacy/pharmacy_details.dart';
import 'package:pharma/View/Pharmacy/user_info.dart';
import 'package:provider/provider.dart';
import '../../Provider/pharmacy_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Utils/custom_loading.dart';
import '../../Utils/search_bar.dart';
import 'add_new_post_page.dart';
import 'add_pharmacists.dart';

enum options { delete, edit, addPharmacists }

class Pharmacy extends StatefulWidget {
  Pharmacy({Key? key, this.isMyPharmacyPage}) : super(key: key);
  bool? isMyPharmacyPage;

  @override
  State<Pharmacy> createState() => _PharmacyState();
}

class _PharmacyState extends State<Pharmacy> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmacy Directory",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: null,
      ),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 80.h),
                child: Consumer<PharmacyProvider>(
                  builder: (context, provider, child) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("pharmacy")
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Something went wrong"));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return buildLoadingWidget();
                        }

                        final data = snapshot.data;
                        if (data != null) {
                          size = data.size;
                        }

                        return Consumer<SearchProvider>(
                          builder: (context, provider, child) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                String name = data?.docs[index]["pharmacyName"];
                                if (name.toLowerCase().contains(provider
                                    .pharmacySearchText
                                    .toLowerCase())) {
                                  if (widget.isMyPharmacyPage != null) {

                                    if (pro.currentUserUid == data?.docs[index]["ownerUid"]) {
                                      return _buildPharmacy(context, data, index, pro);
                                    }
                                    return const SizedBox();
                                  }
                                  return _buildPharmacy(
                                      context, data, index, pro);
                                }
                                return const SizedBox();
                              },
                              itemCount: size,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: buildSearch(context, "pharmacy"),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildPharmacy(BuildContext context,
      QuerySnapshot<Object?>? data, int index, ProfileProvider pro) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PharmacyDetail(
              data: data?.docs[index],
            ),
          ),
        );
      },
      child: Container(
        width: 350.w,
        margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
        padding: EdgeInsets.fromLTRB(20.w, 21.h, 5, 20.h),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffE3E3E3), width: 1),
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
                  style: GoogleFonts.inter(fontSize: 15.sp, height: 1.4),
                ),
              ),
            ),
            Divider(
              height: 20.h,
              color: Colors.black12,
            ),
            Stack(
              children: [
                UserInfoOfAPost(
                  uid: data?.docs[index]["ownerUid"],
                  time: data?.docs[index]["dateTime"],
                  address: data?.docs[index]["address"],
                ),
                if (pro.currentUserUid == data?.docs[index]["ownerUid"])
                  Positioned(
                    right: 0,
                    child: PopupMenuButton<options>(
                      icon: const Icon(Icons.more_vert_rounded),
                      padding: EdgeInsets.zero,
                      onSelected: (options result) {
                        if (result == options.delete) {
                          _showMyDialog(context, data?.docs[index].id ?? "");
                        } else if (result == options.edit) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNewPostPage(
                                documentSnapshot: data?.docs[index],
                              ),
                            ),
                          );
                        } else if (result == options.addPharmacists) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPharmacists(
                                pharmacyId: data!.docs[index].id,
                              ),
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
                          child: Text('Add User'),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
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
                  .deletePharmacy(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
