import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/Pharmacy/single_user.dart';
import 'package:provider/provider.dart';

import '../../../Provider/profile_provider.dart';
import '../../../Utils/custom_loading.dart';


enum SampleItem { admin, driver, user }

class SinglePharmasist extends StatefulWidget {
   SinglePharmasist({Key? key, required this.pharmacyId,required this.creatorId}) : super(key: key);
  String pharmacyId;
  String creatorId;
  @override
  State<SinglePharmasist> createState() => _SinglePharmasistState();
}

class _SinglePharmasistState extends State<SinglePharmasist> {
  @override
  Widget build(BuildContext context) {
    print(widget.pharmacyId);
    print("************************** widget.pharmacyId");
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("pharmacy")
          .doc(widget.pharmacyId)
          .collection("pharmacies").snapshots(),
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

            return SingleUser(uid: data?.docs[index]["pharmaciesId"],docId: data!.docs[index].id,pharmacyId: widget.pharmacyId,ownerId:  widget.creatorId,);

          },
          itemCount: data?.size,
        );
      },
    );
  }


}
