import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Provider/profile_provider.dart';
import '../../../Utils/custom_loading.dart';

enum SampleItem { admin, driver, user }

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data;
        if (data != null) {}
        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            String name = data?.docs[index]["name"];

            return Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 350,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        data?.docs[index]["url"] != ""
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 21,
                                backgroundImage: NetworkImage(
                                  data?.docs[index]["url"],
                                ),
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 21,
                                backgroundImage:
                                    AssetImage("assets/profile.jpg"),
                              ),
                        SizedBox(width: 12.w),
                        Text(
                          name.length > 13
                              ? '${name.substring(0, 13)}...'
                              : name,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Consumer<ProfileProvider>(
                          builder: (context, provider, child) {
                            return changeRole(data?.docs[index]["role"], index);
                          },
                        ),
                        SizedBox(width: 10.w),
                        pro.role == "admin" || pro.role == "contractor"
                            ?  Icon(
                                Icons.edit,
                                size: 15.sp,
                                color: Colors.red,
                              )
                            : SizedBox(width: 40.w),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                )
              ],
            );
          },
          itemCount: data?.size,
        );
      },
    );
  }

  Widget changeRole(String role, int index) {
    //return customButton(text: "Admin", color: primaryColor, fontSize: 15, height: 70, width: 100);
    return Center(
      child: Text(
        role == "admin"
            ? "Admin"
            : role == "contractor"
                ? "Contractor"
                : "User",
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
