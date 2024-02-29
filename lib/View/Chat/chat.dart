import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Auth/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool showLogin = false;

  @override
  void initState() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showLogin = true;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200.h,
              child: Image.asset("assets/message.png"),
            ),
            SizedBox(height: 20.h),
            Text(
              "You are not logged in. To view messages, please log in.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,

              ),
            ),
            SizedBox(height: 20.h),
            if (showLogin)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("SignIn");
                },
                child: roundedButton("Sign in / Register"),
              ),

          ],
        ),
      ),
    );
  }
}
