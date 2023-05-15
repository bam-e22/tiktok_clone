import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential userCredential) async {
    if (userCredential.user == null) {
      throw Exception("Account not created");
    }
    state = AsyncValue.data(
      UserProfileModel(
          bio: "undefined",
          link: "undefined",
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? "anon@anon.com",
          name: userCredential.user!.displayName ?? "Anon"),
    );
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
