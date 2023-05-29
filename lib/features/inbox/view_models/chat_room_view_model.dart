import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_room_repo.dart';
import 'package:tiktok_clone/router.dart';
import 'package:tiktok_clone/utils.dart';

class ChatRoomViewModel extends AutoDisposeAsyncNotifier<void> {
  late final AuthenticationRepository _authRepository;
  late final ChatRoomRepository _chatRoomRepository;

  @override
  FutureOr<void> build() {
    _authRepository = ref.read(authRepo);
    _chatRoomRepository = ref.read(chatRoomRepo);
  }

  Future<void> createChatRoom({
    required BuildContext context,
    required String otherUid,
  }) async {
    state = const AsyncValue.loading();
    final me = _authRepository.user;
    final chatRoomId = "${me!.uid}000$otherUid";
    state = await AsyncValue.guard(
      () async {
        _chatRoomRepository.createChatRoom(
          chatRoomId: chatRoomId,
          uid: me.uid,
          otherUid: otherUid,
        );
      },
    );
    if (!context.mounted) return;
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error as FirebaseException);
    } else {
      context.pushNamed(
        Routes.chatDetailScreen,
        pathParameters: {"chatRoomId": chatRoomId},
      );
    }
  }
}

final chatRoomProvider =
    AsyncNotifierProvider.autoDispose<ChatRoomViewModel, void>(
  () => ChatRoomViewModel(),
);
