import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';
import 'package:tiktok_clone/utils.dart';

class UsersViewModel extends AutoDisposeAsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profileJson = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);

      if (profileJson != null) {
        log("profileJson= $profileJson");
        return UserProfileModel.fromJson(profileJson);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserProfileModel userProfileModel) async {
    state = const AsyncValue.loading();
    await _usersRepository.createProfile(userProfileModel);
    state = AsyncValue.data(userProfileModel);
  }

  Future<void> onAvatarUploaded() async {
    state = AsyncValue.data(
      state.value!.copyWith(hasAvatar: true),
    );
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
    print("onAvatarUploaded");
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    state = AsyncValue.data(state.value!.updateWith(data));
    await _usersRepository.updateUser(state.value!.uid, data);
  }
}

final usersProvider =
    AsyncNotifierProvider.autoDispose<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
