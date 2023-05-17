import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;

  @override
  FutureOr<UserProfileModel> build() {
    _userRepository = ref.read(userRepo);
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserProfileModel userProfileModel) async {
    state = const AsyncValue.loading();
    await _userRepository.createProfile(userProfileModel);
    state = AsyncValue.data(userProfileModel);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
