import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/router.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    await _db.collection("users").doc(user!.uid).update({"token": token});
  }

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    print("permission.authorizationStatus= ${permission.authorizationStatus}");
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    // device state: foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("I just got a message and I'm in the foreground");
      print(message.notification?.title);
    });

    // background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      print(event.data['screen']);
      context.pushNamed(Routes.chatsScreen); // for test
    });

    // terminated
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {
      print(notification.data['screen']);
      context.pushNamed(Routes.activityScreen); // for test
    }
  }

  @override
  FutureOr build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    await initListeners(context);
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);
