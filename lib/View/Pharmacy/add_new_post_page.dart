
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../Provider/pharmacy_provider.dart';
import '../../Utils/custom_loading.dart';
import '../Auth/widgets/round_button.dart';

class AddNewPostPage extends StatefulWidget {
  AddNewPostPage({Key? key,  this.documentSnapshot})
      : super(key: key);

  DocumentSnapshot? documentSnapshot;

  @override
  _AddNewPostPageState createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {


  Future uploadNotice() async {
    try {
      //buildLoadingIndicator(context);
      String url = "";


      Provider.of<PharmacyProvider>(context, listen: false).addNewNotice(
        pharmacyName: pharmacyNameController.text,
        address: addressController.text,
        description: descriptionController.text,
        dateTime: DateTime.now().toString(),
        context: context,
      );

      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future updateNotice() async {
    try {
      buildLoadingIndicator(context);
      String url = "";


      if (widget.documentSnapshot != null &&
          widget.documentSnapshot!["imageUrl"] != "") {
        url = widget.documentSnapshot!["imageUrl"];
      }

      Provider.of<PharmacyProvider>(context, listen: false).updateNotice(
        pharmacyName: pharmacyNameController.text,
        address: addressController.text,
        description: descriptionController.text,
        id: widget.documentSnapshot!.id,
        context: context,
      );
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  late TextEditingController pharmacyNameController;
  late TextEditingController descriptionController;
  late TextEditingController addressController;

  @override
  void initState() {
    if (widget.documentSnapshot != null) {
      pharmacyNameController =
          TextEditingController(text: widget.documentSnapshot!["pharmacyName"]);
      addressController =
          TextEditingController(text: widget.documentSnapshot!["address"]);
      descriptionController =
          TextEditingController(text: widget.documentSnapshot!["description"]);
    } else {
      pharmacyNameController = TextEditingController();
      descriptionController = TextEditingController();
      addressController = TextEditingController();
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
                      child:  buildButton(
                        widget.documentSnapshot == null ? "Create" : "Update",
                        90,
                        16,
                        40,
                      ))
                ],
              ),
            ),
            buildTextField(pharmacyNameController ,"Pharmacy Name"),
            buildTextField(addressController , "Address"),
            buildTextField(descriptionController,"Description", maxLine: 6 ),


          ],
        ),
      ),
    );
  }

  Padding buildTextField( TextEditingController controller,String text, {int maxLine = 1}) {
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
Container buildButton(String text,double width,double size,double height) {
  return Container(
    height: height.h,
    width: width.w,
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: size.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}