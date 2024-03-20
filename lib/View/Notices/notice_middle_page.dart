import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma/View/Chat/lodged_in_chat.dart';
import 'package:pharma/View/Chat/lodged_out_chat.dart';
import '../Auth/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'lodged_in_notice.dart';
import 'lodged_out_notice.dart';

class NoticeMiddlePage extends StatefulWidget {
  const NoticeMiddlePage({super.key});

  @override
  State<NoticeMiddlePage> createState() => _NoticeMiddlePageState();
}

class _NoticeMiddlePageState extends State<NoticeMiddlePage> {
  bool isLodgedIn = false;

  @override
  void initState() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isLodgedIn = true;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isLodgedIn ? const LodgedInNotice() : const LodgedOutNotice(),
    );
  }


}
