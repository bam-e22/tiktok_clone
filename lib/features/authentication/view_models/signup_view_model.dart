import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/router.dart';
import 'package:tiktok_clone/utils.dart';

class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> emailSignUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signupForm);
    final users = ref.read(usersProvider.notifier);
    state = await AsyncValue.guard(
      () async {
        // create account
        final userCredential = await _authRepo.emailSignUp(
          email: form["email"],
          password: form["password"],
        );

        if (userCredential.user == null) {
          throw Exception("Account not created");
        }

        // create profile
        final profile = UserProfileModel(
          hasAvatar: false,
          bio: form["birthday"],
          link: "",
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? form["email"],
          name: form["name"] ?? userCredential.user!.displayName ?? "Anon",
        );
        await users.createProfile(profile);

        return;
      },
    );
    if (!context.mounted) return;
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error as FirebaseException?);
    } else {
      context.goNamed(Routes.interestsScreen);
    }
  }
}

final signupForm = StateProvider((ref) => {});
final signUpProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () => SignupViewModel(),
);
