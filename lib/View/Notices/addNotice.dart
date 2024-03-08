import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import '../../Provider/notice_provider.dart';
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
  Future sendNotification(List<String> tokenIdList, String contents,
      String heading, String url) async {
    try {
      return await post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Basic \u003cZTg0NDI1YzMtNGU3Mi00MDhmLTkwMTYtMmRhYjZhYTJjNDRl\u003e'
        },
        body: jsonEncode(<String, dynamic>{
          "app_id": "kAppId will change",
          //kAppId is the App Id that one get from the OneSignal When the application is registered.

          "included_segments": ["Subscribed Users"],

          "large_icon": url,

          "headings": {"en": heading},

          "contents": {"en": contents},
        }),
      );
    } catch (e) {
      print("---------------------------------------------------------");
      print(e);
    }
  }

  Future uploadNotice() async {
    try {
      print('Response status:******************');


      buildLoadingIndicator(context);

      Provider.of<NoticeProvider>(context, listen: false)
          .addNewNotice(
        postText: postController.text,
        postTitle: titleController.text,
        dateTime: DateTime.now().toString(),
        context: context,
      )
          .then((value) async {
        var client = http.Client();
        try {
          try{
            var client = http.Client();
            await client
                .post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body:jsonEncode( {
              'to': '/topics/adminNotice',
              'notification': {
                'title': 'Check this Mobile (title)',
                'body': 'Rich Notification testing (body)'
              },
              'data': {
                'title': titleController.text,
                'description': postController.text
              }
            }), headers: {
              'Content-Type': 'application/json',
              // Example header
              'Authorization':
              'key=AAAA11afjE8:APA91bHvhOsfthYzR0RRlZ2pwdRwwvBeS0FOvpaI5_sdU8X5TYFwVpGoRr39WrZf9N5OTysmzc8ltc-hmpNnNAwiwmvdqgJAxK0mPRiEyn4OzmWM4muCvfW0mi7SWHrCUTFvo7eA7DdO',
              // Example header for authentication
            });


          }catch(e){
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
            buildTextField(titleController, "Title"),
            buildTextField(postController, "Description", maxLine: 6),
          ],
        ),
      ),
    );
  }
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
