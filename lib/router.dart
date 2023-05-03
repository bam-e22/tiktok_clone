import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';

import 'features/authentication/email_screen.dart';

class Routes {
  static const String SignUp = "signup";
  static const String Username = "username";
  static const String Email = "email";

  static const String SignUpPath = "/";
  static const String LoginPath = "/login";
  static const String UsernamePath = "username";
  static const String EmailPath = "email";
}

final router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.SignUp,
      path: Routes.SignUpPath,
      builder: (context, state) => SignUpScreen(),
      routes: [
        GoRoute(
            name: Routes.Username,
            path: Routes.UsernamePath,
            builder: (context, state) => UsernameScreen(),
            routes: [
              GoRoute(
                name: Routes.Email,
                path: Routes.EmailPath,
                builder: (context, state) {
                  var args = state.extra as EmailScreenArgs?;
                  print("args= $args");
                  return EmailScreen(
                    username: args?.username ?? "user",
                  );
                },
              ),
            ]),
      ],
    ),
/*    GoRoute(
      path: Routes.LoginScreen,
      builder: (context, state) => LoginScreen(),
    ),*/
  ],
);
