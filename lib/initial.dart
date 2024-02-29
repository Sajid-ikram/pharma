import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/profile_provider.dart';
import 'Utils/custom_loading.dart';
import 'View/Auth/verification.dart';
import 'custom_nev.dart';

class Initial extends StatefulWidget {
  const Initial({Key? key}) : super(key: key);

  @override
  State<Initial> createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAXuKthNAleNpyiIGEoOKyAKje9_2q1dS4",
      appId: "1:924871265359:android:361c37964409bff1e2ae3a",
      messagingSenderId: "924871265359",
      projectId: "pharma-d27ac",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Error")));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const MiddleOfHomeAndSignIn();
        }
        return const Scaffold(
            body: Center(child: Text("Something Went Wrong")));
      },
    );
  }
}

class MiddleOfHomeAndSignIn extends StatefulWidget {
  const MiddleOfHomeAndSignIn({Key? key}) : super(key: key);

  @override
  _MiddleOfHomeAndSignInState createState() => _MiddleOfHomeAndSignInState();
}

class _MiddleOfHomeAndSignInState extends State<MiddleOfHomeAndSignIn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        }
        if (snapshot.data != null && snapshot.data!.emailVerified) {
          return const CustomNavigation();
        }
        return snapshot.data == null
            ? const CustomNavigation()
            : const Verification();
      },
    );
  }
}
