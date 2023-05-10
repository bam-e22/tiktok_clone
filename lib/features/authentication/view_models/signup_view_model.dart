import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  Future<void> emailSignUp() async {
    state = const AsyncValue.loading();
    final form = ref.read(signupForm);
    state = await AsyncValue.guard(
      () async => await _authRepo.emailSignUp(
        email: form["email"],
        password: form["password"],
      ),
    );
  }

  @override
  FutureOr<void> build() {
    // nothing to return
    _authRepo = ref.read(authRepo);
  }
}

final signupForm = StateProvider((ref) => {});
final signUpProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () => SignupViewModel(),
);
