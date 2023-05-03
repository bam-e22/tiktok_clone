import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';

import 'features/authentication/email_screen.dart';

class Routes {
  static const String SignUpScreen = "/";
  static const String LoginScreen = "/login";
  static const String UsernameScreen = "/username";
  static const String EmailScreen = "/email";
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.SignUpScreen,
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: Routes.LoginScreen,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: Routes.UsernameScreen,
      builder: (context, state) => UsernameScreen(),
    ),
    GoRoute(
      path: Routes.EmailScreen,
      builder: (context, state) => EmailScreen(),
    ),
  ],
);
