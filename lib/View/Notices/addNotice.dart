import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import '../../Provider/notice_provider.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/custom_loading.dart';
import '../../Utils/error_dialoge.dart';
import '../Pharmacy/add_new_post_page.dart';
import 'package:http/http.dart' as http;

class AddNotice extends StatefulWidget {
  AddNotice({Key? key, this.documentSnapshot}) : super(key: key);
  DocumentSnapshot? documentSnapshot;

  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  Future uploadNotice() async {
    try {
      print('Response status:******************');

      buildLoadingIndicator(context);

      Provider.of<NoticeProvider>(context, listen: false)
          .addNewNotice(
        postText: postController.text,
        postTitle: titleController.text,
        databaseName: databaseName,
        dateTime: DateTime.now().toString(),
        context: context,
      )
          .then((value) async {
        var client = http.Client();
        try {
          try {
            // i know this is not a good way of sending notification but I don't
            // have enough time to make a custom backend to store auth key and manage this process from the backend.
            var client = http.Client();
            await client.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: jsonEncode({
                  'to': '/topics/$databaseName',
                  "priority": "high",
                  'notification': {
                    'title': titleController.text.isEmpty
                        ? 'Pharma'
                        : titleController.text,
                    'body': postController.text.isEmpty
                        ? 'You have a new notice'
                        : postController.text
                  },
                  'data': {
                    'title': titleController.text,
                    'description': postController.text
                  }
                }),
                headers: {
                  'Content-Type': 'application/json',
                  // Example header
                  'Authorization':
                      'key=AAAA11afjE8:APA91bHvhOsfthYzR0RRlZ2pwdRwwvBeS0FOvpaI5_sdU8X5TYFwVpGoRr39WrZf9N5OTysmzc8ltc-hmpNnNAwiwmvdqgJAxK0mPRiEyn4OzmWM4muCvfW0mi7SWHrCUTFvo7eA7DdO',
                  // Example header for authentication
                });
          } catch (e) {
            onError(context, "Something went wrong, can not send notification");
          }
        } finally {
          client.close();
        }
      });
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future updateNotice() async {
    try {
      buildLoadingIndicator(context);

      Provider.of<NoticeProvider>(context, listen: false).updateNotice(
        postText: postController.text,
        id: widget.documentSnapshot!.id,
        postTitle: titleController.text,
        databaseName: databaseName,
        context: context,
      );
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  late TextEditingController postController;
  late TextEditingController titleController;
  String page = "All Users";
  String databaseName = "notice";

  @override
  void initState() {
    if (widget.documentSnapshot != null) {
      postController =
          TextEditingController(text: widget.documentSnapshot!["postText"]);
      postController =
          TextEditingController(text: widget.documentSnapshot!["postTitle"]);
    } else {
      postController = TextEditingController();
      titleController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 30.sp,
                      )),
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (widget.documentSnapshot == null) {
                          uploadNotice();
                        } else {
                          updateNotice();
                        }
                      },
                      child: buildButton(
                        widget.documentSnapshot == null ? "Post" : "Update",
                        90,
                        16,
                        40,
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 21.h, 30.w, 20.h),
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
                    child: _buildButton("All Users", page == "All Users"),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        page = "Contractor";
                        databaseName = "contractorNotice";
                      });
                    },
                    child: _buildButton("Contractor", page == "Contractor"),
                  ),
                ],
              ),
            ),
            buildTextField(titleController, "Title"),
            buildTextField(postController, "Description", maxLine: 6),
          ],
        ),
      ),
    );
  }
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

Widget buildTitleText(String text, double size, double height) {
  return Container(
    alignment: Alignment.centerLeft,
    width: 220,
    child: Text(
      text,
      style: GoogleFonts.poppins(color: Color(0xffFCCFA8), fontSize: size),
    ),
  );
}

Padding buildTextField(TextEditingController controller, String text,
    {int maxLine = 1}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
    child: TextField(
      maxLines: maxLine,
      style: const TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        fillColor: Color(0xffC4C4C4).withOpacity(0.2),
        filled: true,
        hintText: text,
        hintStyle: GoogleFonts.inter(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          // Set desired corner radius
          borderSide: BorderSide.none, // Set border color (optional)
        ),
      ),
    ),
  );
}
