import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../View/Auth/widgets/snackBar.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<String> signIn(
      String email, String password, BuildContext context) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final token = await FirebaseMessaging.instance.getToken();
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.user?.uid)
          .update(
        {
          "token": token,
        },
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      print(e);
      print(e.code);
      print("-------------------------------------------- e.code");
      switch (e.code) {

        case "invalid-email":
          return "Your email address appears to be malformed.";
        case "wrong-password":
          return "Wrong password";

        case "user-not-found":
          return "User with this email doesn't exist.";

        case "user-disabled":
          return "User with this email has been disabled.";

        case "invalid-credential":
          return "invalid credential";

        default:
          return "An undefined Error happened.";
      }
    } catch (e) {
      return "An Error occur";
    }
  }

  Future<String> signUp(
      {required String name,
      required String email,
      required String password,
      required String fCode,
      required context,
      bool isRegistration = true}) async {
    try {
      _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then(
        (value) async {
          print("--------------------------+++++++++++++++++++++++555555555");
          Navigator.of(context, rootNavigator: true).pop();
          if (isRegistration)
            Navigator.of(context).pushReplacementNamed("MiddleOfHomeAndSignIn");
          final token = await FirebaseMessaging.instance.getToken();
          FirebaseFirestore.instance
              .collection("users")
              .doc(value.user!.uid)
              .set(
            {
              "name": name,
              "email": value.user!.email,
              "url": "",
              "role": fCode.isEmpty ? "" : "contractor",
              "token": token
            },
          );
        },
      ).catchError((error) {
        Navigator.of(context, rootNavigator: true).pop();
        switch (error.code) {
          case "weak-password":
            snackBar(context, "Your password is too weak");

          case "invalid-email":
            snackBar(context, "Your email is invalid");


          case "email-already-in-use":
            snackBar(context, "Email is already in use on different account");

          default:
            snackBar(context, "An undefined Error happened.");
        }
      });

      return "Success";
    } on FirebaseAuthException catch (e) {
      print("--------------------------+++++++++++++++++++++++0");
      Navigator.of(context, rootNavigator: true).pop();
      switch (e.code) {
        case "weak-password":
          return "Your password is too weak";

        case "invalid-email":
          return "Your email is invalid";

        case "email-already-in-use":
          return "Email is already in use on different account";

        default:
          return "An undefined Error happened.";
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      print("--------------------------+++++++++++++++++++++++1 11 1");
      return "An Error occur";
    }
  }

  Future<String> createUser(
      {required String name,
      required String email,
      required String password,
      required String department,
      required String pharmacyId,
      required context,
      bool isRegistration = true}) async {
    try {
      var secondaryAppOptions = const FirebaseOptions(
        // Replace with your actual Firebase project configuration
        apiKey: "AIzaSyAXuKthNAleNpyiIGEoOKyAKje9_2q1dS4",
        appId: "1:924871265359:android:361c37964409bff1e2ae3a",
        projectId: "pharma-d27ac",
        messagingSenderId: "924871265359",
      );

      // Initialize the secondary Firebase app
      await Firebase.initializeApp(
          options: secondaryAppOptions, name: 'secondary');

      // Use the secondary app for user creation
      final auth = FirebaseAuth.instanceFor(app: Firebase.app('secondary'));
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context, rootNavigator: true).pop();
      if (credential.user != null) {
        await credential.user!.sendEmailVerification();
        FirebaseFirestore.instance
            .collection("users")
            .doc(credential.user!.uid)
            .set(
          {
            "name": name,
            "email": credential.user!.email,
            "url": "",
            "role": "",
            "token": "",
          },
        );
        FirebaseFirestore.instance
            .collection("pharmacy")
            .doc(pharmacyId)
            .collection("pharmacies")
            .add({"pharmaciesId": credential.user!.uid});
      }

      // Delete the secondary app (consider keeping it if needed)
      await Firebase.app('secondary').delete();
      return "Success";
    } on FirebaseAuthException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      switch (e.code) {
        case "weak-password":
          return "Your password is too weak";

        case "invalid-email":
          return "Your email is invalid";

        case "email-already-in-use":
          return "Email is already in use on different account";

        default:
          return "An undefined Error happened.";
      }
    } catch (e) {
      return "An Error occur";
    }
  }

/*  Future<bool> createUser(String email, String password) async {
    try {
      // Create Firebase app options for the secondary app


      // Handle success (optional: send verification email)

    }  catch (e) {
      // Handle errors
      print(e);
      print("88888888888888888888888888888888888");
      return false;
    }
  }*/

  Future signOut() async {
    await _firebaseAuth.signOut();

    notifyListeners();
  }

  Future<String> resetPassword(String email, BuildContext context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return "Success";
    } catch (e) {
      return "Error";
    }
  }

  Future deleteUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .delete();
      user.delete();
    }
  }
}
