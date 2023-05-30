import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_room_repo.dart';
import 'package:tiktok_clone/router.dart';

class ChatRoomViewModel extends AutoDisposeAsyncNotifier<List<ChatRoomModel>> {
  late final AuthenticationRepository _authRepository;
  late final ChatRoomRepository _chatRoomRepository;

  List<ChatRoomModel> _list = [];

  @override
  FutureOr<List<ChatRoomModel>> build() async {
    _authRepository = ref.read(authRepo);
    _chatRoomRepository = ref.read(chatRoomRepo);
    await _fetchChatRooms();
    return _list;
  }

  Future<void> _fetchChatRooms() async {
    state = const AsyncValue.loading();
    final me = _authRepository.user;
    state = await AsyncValue.guard(() async {
      final result = await _chatRoomRepository.fetchChatRooms(me!.uid);
      for (var doc in result.docs) {
        final data = doc.data();
        final otherUid = data["personB"];
        final otherName = await _chatRoomRepository.getUserName(otherUid);
        final lastMessage = await _chatRoomRepository.getLastMessage(doc.id);
        final chatRoom = ChatRoomModel(
          chatRoomId: doc.id,
          createdAt: data["createdAt"],
          otherUid: otherUid,
          otherName: otherName,
          lastMessage: lastMessage,
        );
        _list = [..._list, chatRoom];
      }
      return _list;
    });
  }

  Future<void> createChatRoom({
    required BuildContext context,
    required String otherUid,
  }) async {
    final me = _authRepository.user;
    final chatRoomId = "${me!.uid}000$otherUid";
    await _chatRoomRepository.createChatRoom(
      chatRoomId: chatRoomId,
      uid: me.uid,
      otherUid: otherUid,
    );
    if (!context.mounted) return;
    context.pop();
    context.pushNamed(
      Routes.chatDetailScreen,
      pathParameters: {"chatRoomId": chatRoomId},
    );
  }

  Future<void> deleteChatRoom({
    required String chatRoomId,
  }) async {
    await _chatRoomRepository.deleteChatRoom(
      chatRoomId: chatRoomId,
    );
  }
}

final chatRoomProvider =
    AsyncNotifierProvider.autoDispose<ChatRoomViewModel, List<ChatRoomModel>>(
  () => ChatRoomViewModel(),
);
