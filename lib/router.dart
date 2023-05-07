import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

enum MainTabs { home, discover, camera, inbox, profile }

class Routes {
  static const String SignUpRoute = "signup";
  static const String SignUpScreen = "/";
  static const String LoginRoute = "login";
  static const String LoginScreen = "/login";
  static const String InterestsRoute = "interests";
  static const String InterestsScreen = "/interests";
  static const String MainRoute = "main";
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
    GoRoute(
      name: Routes.MainRoute,
      path:
          "/:tab(${MainTabs.home.name}|${MainTabs.discover.name}|${MainTabs.inbox.name}|${MainTabs.profile.name})",
      builder: (context, state) {
        final String tab = state.pathParameters["tab"] ?? MainTabs.home.name;
        return MainNavigationScreen(tab: tab);
      },
    )
  ],
);
