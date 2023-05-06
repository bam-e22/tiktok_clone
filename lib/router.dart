import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

class Routes {
  static const String SignUpRoute = "signup";
  static const String SignUpScreen = "/";
  static const String LoginRoute = "login";
  static const String LoginScreen = "/login";
  static const String InterestsRoute = "interests";
  static const String InterestsScreen = "/interests";
}

final router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.SignUpRoute,
      path: Routes.SignUpScreen,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: Routes.LoginRoute,
      path: Routes.LoginScreen,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: Routes.InterestsRoute,
      path: Routes.InterestsScreen,
      builder: (context, state) => const InterestsScreen(),
    ),
  ],
);
