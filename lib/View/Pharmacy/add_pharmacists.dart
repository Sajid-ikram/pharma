import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma/View/Auth/widgets/page_indicator.dart';
import 'package:pharma/View/Auth/widgets/round_button.dart';
import 'package:pharma/View/Auth/widgets/snackBar.dart';
import 'package:pharma/View/Auth/widgets/switch_page.dart';
import 'package:pharma/View/Auth/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Provider/authentication.dart';
import '../../Utils/custom_loading.dart';
import 'add_new_post_page.dart';

class AddPharmacists extends StatefulWidget {
  const AddPharmacists({Key? key}) : super(key: key);

  @override
  State<AddPharmacists> createState() => _AddPharmacistsState();
}

class _AddPharmacistsState extends State<AddPharmacists> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .createUser(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          department: "change it",
          context: context,
          isRegistration: false,
        )
            .then((value) async {
          if (value != "Success") {
            snackBar(context, value);
          } else {
            Navigator.of(context).pop();
            snackBar(context, "Pharmacists created");
            if (FirebaseAuth.instance.currentUser != null) {
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 30.h),
              Row(
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
                        validate();
                      },
                      child:  buildButton(
                        "Create" ,
                        90,
                        16,
                        40,
                      ))
                ],
              ),
              SizedBox(height: 30.h),
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


                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
