import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';

import 'features/authentication/email_screen.dart';
import 'features/users/user_profile_screen.dart';

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
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: UsernameScreen(),
          transitionDuration: Duration(milliseconds: 300),
          reverseTransitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: Routes.EmailScreen,
      builder: (context, state) {
        var args = state.extra as EmailScreenArgs?;
        print("args= $args");
        return EmailScreen(
          username: args?.username ?? "user",
        );
      },
    ),
    GoRoute(
      path: "/users/:username",
      builder: (context, state) {
        print("state.params= ${state.queryParameters}");
        return UserProfileScreen();
      },
    )
  ],
);
