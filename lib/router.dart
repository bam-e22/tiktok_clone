import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

enum MainTabs { home, discover, camera, inbox, profile }

class Routes {
  static const String signUpScreen = "signup";
  static const String signUpUrl = "/";
  static const String loginScreen = "login";
  static const String loginUrl = "/login";
  static const String interestsScreen = "interests";
  static const String interestsUrl = "/interests";
  static const String mainScreen = "main";
  static const String activityScreen = "activity";
  static const String activityUrl = "/activity";
  static const String chatsScreen = "chats";
  static const String chatsUrl = "/chats";
  static const String chatDetailScreen = "chatDetail";
  static const String chatDetailUrl = ":chatId"; // /chat/:chatId
}

final router = GoRouter(
  initialLocation: "/inbox", // for debug
  routes: [
    GoRoute(
      name: Routes.signUpScreen,
      path: Routes.signUpUrl,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: Routes.loginScreen,
      path: Routes.loginUrl,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: Routes.interestsScreen,
      path: Routes.interestsUrl,
      builder: (context, state) => const InterestsScreen(),
    ),
    GoRoute(
      name: Routes.mainScreen,
      path:
          "/:tab(${MainTabs.home.name}|${MainTabs.discover.name}|${MainTabs.inbox.name}|${MainTabs.profile.name})",
      builder: (context, state) {
        final String tab = state.pathParameters["tab"] ?? MainTabs.home.name;
        return MainNavigationScreen(tab: tab);
      },
    ),
    GoRoute(
      name: Routes.activityScreen,
      path: Routes.activityUrl,
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      name: Routes.chatsScreen,
      path: Routes.chatsUrl,
      builder: (context, state) => const ChatsScreen(),
      routes: [
        // child nested route "/chats:chatId"
        GoRoute(
          name: Routes.chatDetailScreen,
          path: Routes.chatDetailUrl,
          builder: (context, state) {
            print("chatId= ${state.pathParameters["chatId"]}");
            final chatId = state.pathParameters["chatId"]!;
            return ChatDetailScreen(chatId: chatId);
          },
        ),
      ],
    ),
  ],
);
