import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Provider/authentication.dart';
import 'Provider/profile_provider.dart';
import 'Utils/app_colors.dart';
import 'View/Auth/registration.dart';
import 'View/Auth/signin.dart';
import 'View/Profile/profile.dart';
import 'initial.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  /*await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAXuKthNAleNpyiIGEoOKyAKje9_2q1dS4",
      appId: "1:924871265359:android:361c37964409bff1e2ae3a",
      messagingSenderId: "924871265359",
      projectId: "pharma-d27ac",
    ),
  );*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'LU Bird',
              theme: _buildTheme(Brightness.light),
              home: const Initial(),
              routes: {
                "SignIn": (ctx) => const SignIn(),
                "Registration": (ctx) => const Registration(),
                "MiddleOfHomeAndSignIn": (ctx) => const MiddleOfHomeAndSignIn(),
                "Profile": (ctx) =>  const Profile(),

              });
        },
      ),
    );
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(
    brightness: brightness,
    primarySwatch: greenSwatch,
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
    primaryColor: const Color(0xff425C5A),
    scaffoldBackgroundColor: Colors.white,
  );
}
