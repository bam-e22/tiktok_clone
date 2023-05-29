import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';

class ChatUsersViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authRepository;
  List<UserProfileModel> _users = [];

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _userRepository = ref.read(userRepo);
    _authRepository = ref.read(authRepo);
    _users = await _fetchAllUsers(lastUserUid: null);
    return _users;
  }

  Future<List<UserProfileModel>> _fetchAllUsers({String? lastUserUid}) async {
    final me = _authRepository.user;
    final result =
        await _userRepository.fetchAllUsers(lastUserUid: lastUserUid);
    final users = result.docs
        .map(
          (doc) => UserProfileModel.fromJson(
            doc.data(),
          ),
        )
        .where((user) => user.uid != me!.uid)
        .toList();

    return users;
  }
}

final chatUsersProvider =
    AsyncNotifierProvider<ChatUsersViewModel, List<UserProfileModel>>(
  () => ChatUsersViewModel(),
);
