import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createChatRoom({
    required String chatRoomId,
    required String uid,
    required String otherUid,
  }) async {
    final query = _db.collection("chat_rooms").doc(chatRoomId);
    final chatRoom = await query.get();
    if (!chatRoom.exists) {
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "personA": uid,
        "personB": otherUid,
      });
    }
  }

  fetchChatRooms(String uid) {}
}

final chatRoomRepo = Provider(
  (ref) => ChatRoomRepository(),
);
