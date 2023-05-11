import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/router.dart';
import 'package:tiktok_clone/utils.dart';

class SocialAuthViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  Future<void> githubSignIn(BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _repository.githubSignIn(),
    );
    if (!context.mounted) return;
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error as FirebaseException?);
    } else {
      context.go("/${MainTabs.home.name}");
    }
  }

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }
}

final socialAuthProvider = AsyncNotifierProvider<SocialAuthViewModel, void>(
  () => SocialAuthViewModel(),
);
