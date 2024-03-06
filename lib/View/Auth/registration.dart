import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma/Utils/fcode.dart';
import 'package:pharma/View/Auth/widgets/page_indicator.dart';
import 'package:pharma/View/Auth/widgets/round_button.dart';
import 'package:pharma/View/Auth/widgets/snackBar.dart';
import 'package:pharma/View/Auth/widgets/switch_page.dart';
import 'package:pharma/View/Auth/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Provider/authentication.dart';
import '../../Utils/custom_loading.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fcodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    fcodeController.clear();
    super.dispose();
  }

  validate() async {
    if (fcodeController.text.isNotEmpty) {
      if (!fcodeList.contains(fcodeController.text)) {
        snackBar(context, "Code does not match");
        return;
      }
    }
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .signUp(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          fCode: fcodeController.text.isEmpty ? "" : fcodeController.text,
          context: context,
        )
            .then((value) async {
          if (value != "Success") {
            snackBar(context, value);
          } else {
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              user.sendEmailVerification();
            }
          }
        });
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "Some error occur");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(30.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 45.h),
              SizedBox(
                height: 150.h,
                child: Image.asset("assets/site_logo.jpeg"),
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    customTextField(nameController, "Full name", context,
                        Icons.person_outline_rounded),
                    SizedBox(height: 20.h),
                    customTextField(emailController, "NHS email", context,
                        Icons.email_outlined),
                    SizedBox(height: 20.h),
                    customTextField(passwordController, "Password", context,
                        Icons.lock_outline_rounded),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Text(
                          "Write code if you are a Contractor",
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    customTextField(fcodeController, "Contractor ID", context,
                        Icons.password_outlined),
                  ],
                ),
              ),
              SizedBox(height: 17.h),
              switchPageButton("Already Have An Account? ", "Log In", context),
              SizedBox(height: 55.h),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  validate();
                },
                child: roundedButton("Register"),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
