import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/sizes.dart';
import 'features/authentication/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.martelTextTheme(),
        primaryColor: const Color(0xFFE9435A),
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade50,
        ),
        splashColor: Colors.transparent,
        //splashFactory: NoSplash.splashFactory,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.martelTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        primaryColor: const Color(0xFFE9435A),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
      ),
      home: const SignUpScreen(),
      //home: const MainNavigationScreen(), // for debugging
    );
  }
}
