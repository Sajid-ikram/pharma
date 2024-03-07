import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../Utils/custom_loading.dart';
import '../Utils/error_dialoge.dart';

class ProfileProvider extends ChangeNotifier {
  String profileUrl = '';
  String profileName = '';
  String role = '';
  String email = '';
  String currentUserUid = '';

  bool refreshAssignBus = false;

  getUserInfo() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      profileUrl = userInfo["url"];
      profileName = userInfo["name"];
      role = userInfo["role"];
      email = userInfo["email"];
      currentUserUid = user.uid;
      notifyListeners();
    }
  }

  Future updateProfileInfo({
    required String name,
    String? id,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(id ?? currentUserUid)
          .update(
        {
          "name": name,
        },
      );
      if (id == null) profileName = name;

      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future changeRole({
    required String role,
    required String uid,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("users").doc(uid).update(
        {
          "role": role,
        },
      );
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future updateProfileUrl(File _imageFile, BuildContext context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      buildLoadingIndicator(context);
      final ref = FirebaseStorage.instance
          .ref()
          .child("profileImage")
          .child(auth.currentUser!.uid);
      final result = await ref.putFile(_imageFile);
      final url = await result.ref.getDownloadURL();
      FirebaseFirestore.instance.collection("users").doc(currentUserUid).update(
        {"url": url},
      );
      profileUrl = url;
      Navigator.of(context, rootNavigator: true).pop();
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future<DocumentSnapshot> getProfileInfoByUID(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  refreshAssignBusPage() {
    refreshAssignBus = !refreshAssignBus;
    notifyListeners();
  }
}
